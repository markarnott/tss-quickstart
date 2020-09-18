#!/usr/bin/env bash

# This script will download and compile stable versions of TPM2 software.
# The release version numbers are at the top of the script
# If you run this on an ubuntu distribution it will apt-get the dependency packages for the tpm2 software stack
# If not on ubuntu you must install dependencies before this script runs
#    dependencies can be found in the docker files here https://github.com/tpm2-software/tpm2-software-container

tpm2_tss_ver="3.0.0"
tpm2_abrmd_ver="2.3.3"
tpm2_tools_ver="4.3.0"

ibmtpm_sim_ver=ibmtpm1637
ibmtpm_checksum=dd3a4c3f7724243bc9ebcd5c39bbf87b82c696d1c1241cb8e5883534f6e2e327

function main {

   sudo -v
   get_pkgs_4ubuntu

   mkdir -p workspace
   pushd workspace

   # get and build tmp2-tss 
   tss_pkg_name="tpm2-tss-$tpm2_tss_ver"
   tss_dl_url="https://github.com/tpm2-software/tpm2-tss/releases/download/$tpm2_tss_ver/$tss_pkg_name.tar.gz"
   get_release $tss_pkg_name $tss_dl_url

   build_component $tss_pkg_name --prefix=/usr --disable-doxygen-doc

   sudo -v 

   # get and build tmp2-abrmd
   abrmd_pkg_name="tpm2-abrmd-$tpm2_abrmd_ver"
   abrmd_dl_url="https://github.com/tpm2-software/tpm2-abrmd/releases/download/$tpm2_abrmd_ver/$abrmd_pkg_name.tar.gz"
   get_release $abrmd_pkg_name $abrmd_dl_url

   build_component $abrmd_pkg_name --with-dbuspolicydir=/etc/dbus-1/system.d

   sudo -v 

   # get and build tmp2-tools 
   tools_pkg_name="tpm2-tools-$tpm2_tools_ver"
   tools_dl_url="https://github.com/tpm2-software/tpm2-tools/releases/download/$tpm2_tools_ver/$tools_pkg_name.tar.gz"
   get_release $tools_pkg_name $tools_dl_url

   build_component $tools_pkg_name --prefix=/usr/local

   sudo -v 

   # get and build the ibm simulator
   sim_dl_url="https://downloads.sourceforge.net/project/ibmswtpm2/$ibmtpm_sim_ver.tar.gz"
   get_ibm_sim $ibmtpm_sim_ver $sim_dl_url $ibmtpm_checksum

   build_ibm_sim $ibmtpm_sim_ver
   popd

   config_tpm2_stack 
}

function get_pkgs_4ubuntu {

   isubuntu=$(cat /etc/os-release | grep -e "^ID=ubuntu")

   if [[ -n $isubuntu ]]; then 
      sudo apt -y update

      sudo apt -y install wget
      sudo apt -y install autoconf autoconf-archive automake build-essential \
         gcc pkg-config

      sudo apt -y install libtool libssl-dev libjson-c-dev libini-config-dev

      # we could optionally use libcurl4-gnutls-dev instead of openssl-dev
      sudo apt -y install libcurl4-openssl-dev

      # required for abrmd
      sudo apt -y install libglib2.0-dev

      # required for tpm2-tools
      sudo apt -y install uuid-dev python-yaml
   else
      echo "This doesn't look like ubunut.  Did you install dependencies already?  Because we skipped that step."
   fi
}

function get_release {

   if [ ! -f "$1.tar.gz" ]; then
      echo
      echo "=== getting $2 ==="
      echo
      wget --quiet --show-progress --progress=dot:giga $2
      echo
   fi

   echo
   echo "=== extracting $1.tar.gz ==="
   echo
   tar xvf $1.tar.gz

}

function build_component {
   echo
   echo "=== building $1 ==="
   echo
   pushd $1
   ./configure $2 $3

   make | tee build.log
   sudo make install | tee install.log
   popd
}

function get_ibm_sim {
   name=$1
   dl_url=$2
   checksum=$3

   if [ ! -f "$name.tar.gz" ]; then
      echo
      echo "=== getting $dl_url ==="
      echo
      wget --quiet --show-progress --progress=dot:giga $dl_url
      echo 
   fi

   echo "Verifying Checksum for $name.tar.gz"
   sha256sum $name.tar.gz | grep ^$checksum

   echo
   echo "=== extracting $name.tar.gz ==="
   echo
   mkdir -p $name \
      && tar xvf $name.tar.gz -C $name
}

function build_ibm_sim {
   name=$1

   echo
   echo "=== building $name ==="
   echo
   pushd $name/src
 
   make | tee build.log
   sudo install tpm_server /usr/local/bin/tpm_server | tee install.log
   popd
}

function config_tpm2_stack {
   sudo ldconfig

   #sudo useradd --system --user-group tss

   # configure abrmd service to call the simulator instead of physical hardware
   sudo sed -i "s/ConditionPath/#ConditionPath/; s/tpm2-abrmd$/tpm2-abrmd --tcti=mssim/" /usr/local/lib/systemd/system/tpm2-abrmd.service

   sudo systemctl enable tpm2-abrmd
   sudo systemctl daemon-reload

   sudo pkill -HUP dbus-daemon
}

main