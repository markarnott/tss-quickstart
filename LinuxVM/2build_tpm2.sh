#!/usr/bin/env bash

# This script will download and compile stable versions of TPM2 software.
# The release version numbers are at the top of the script
# This script assumes that all packages required for compilation are already installed on the system.
# The 1get_build_tools.sh script will install packages required for compilation 


tpm2_abrmd_ver="2.3.2"
#tpm2_tss_ver="2.4.2"
tpm2_tss_ver="3.0.0"
tpm2_tools_ver="4.1.3"
ibmtpm_sim_ver=ibmtpm1637
ibmtpm_checksum=dd3a4c3f7724243bc9ebcd5c39bbf87b82c696d1c1241cb8e5883534f6e2e327

function main {

   export INSTALL_PATH="$(dirname $(readlink -f $0))/3install_tpm2.sh"

   # create the begining of the install script
   echo "#!/usr/bin/env bash" > $INSTALL_PATH
   echo "" >> $INSTALL_PATH
   chmod +x $INSTALL_PATH

   get_tss $tpm2_tss_ver

   get_abrmd $tpm2_abrmd_ver

   get_tools $tpm2_tools_ver

   get_ibm_sim $ibmtpm_sim_ver $ibmtpm_checksum

}

function append_installer {
   echo ""  $INSTALL_PATH
   echo "pushd $(pwd)" >> $INSTALL_PATH
   echo "make install" >> $INSTALL_PATH
   echo "popd" >> $INSTALL_PATH
}

function get_ibm_sim {
   file_version=$1
   checksum=$2

   if [ ! -f "$file_version.tar.gz" ]; then
      dl_url="https://downloads.sourceforge.net/project/ibmswtpm2/$file_version.tar.gz"
      echo
      echo "=== getting $dl_url ==="
      echo
      wget --quiet --show-progress --progress=dot:giga $dl_url
      echo 
   fi

   echo "Verifying Checksum for $file_version.tar.gz"
   sha256sum $file_version.tar.gz | grep ^$checksum

   echo
   echo "=== extracting $file_version.tar.gz ==="
   echo
   mkdir -p $file_version \
      && tar xvf $file_version.tar.gz -C $file_version

   echo
   echo "=== building $name ==="
   echo
   pushd $file_version/src
 
   make
   echo ""  >> $INSTALL_PATH
   echo "pushd $(pwd)" >> $INSTALL_PATH
   echo "install tpm_server /usr/local/bin/tpm_server" >> $INSTALL_PATH
   echo "popd" >> $INSTALL_PATH
   popd
}

function get_tss {
   file_version=$1

   name="tpm2-tss-$file_version"
   if [ ! -f "$name.tar.gz" ]; then
      dl_url="https://github.com/tpm2-software/tpm2-tss/releases/download/$file_version/$name.tar.gz"
      echo
      echo "=== getting $dl_url ==="
      echo
      wget --quiet --show-progress --progress=dot:giga $dl_url
      echo
   fi

   echo
   echo "=== extracting $name.tar.gz ==="
   echo
   tar xvf $name.tar.gz

   echo
   echo "=== building $name ==="
   echo
   pushd $name
   ./configure --prefix=/usr --disable-doxygen-doc

   make
   append_installer
   export TSS=$(pwd)
   popd
}

function get_abrmd {
   file_version=$1

   name="tpm2-abrmd-$file_version"
   if [ ! -f "$name.tar.gz" ]; then
      dl_url="https://github.com/tpm2-software/tpm2-abrmd/releases/download/$file_version/$name.tar.gz"
      echo
      echo "=== getting $dl_url ==="
      echo
      wget --quiet --show-progress --progress=dot:giga $dl_url
      echo 
   fi

   echo
   echo "=== extracting $name.tar.gz ==="
   echo
   tar xvf $name.tar.gz

   echo
   echo "=== building $name ==="
   echo
   pushd $name
   
   TSS2_SYS_CFLAGS="-I${TSS}/include" TSS2_SYS_LIBS="-ltss2-sys -L$TSS/src/tss2-sys/.libs/" \
   TSS2_MU_CFLAGS="-I${TSS}/include" TSS2_MU_LIBS="-ltss2-mu -L$TSS/src/tss2-mu/.libs/" \
   TSS2_TCTILDR_CFLAGS="-I${TSS}/include" TSS2_TCTILDR_LIBS="-ltss2-tctildr -L$TSS/src/tss2-tcti/.libs/" \
   TSS2_RC_CFLAGS="-I${TSS}/include" TSS2_RC_LIBS="-ltss2-rc -L$TSS/src/tss2-rc/.libs/" \
   ./configure --with-dbuspolicydir=/etc/dbus-1/system.d
   
   make
   append_installer
   popd
}

function get_tools {
   file_version=$1

   name="tpm2-tools-$file_version"
   if [ ! -f "$name.tar.gz" ]; then
      dl_url="https://github.com/tpm2-software/tpm2-tools/releases/download/$file_version/$name.tar.gz"
      echo
      echo "=== getting $dl_url ==="
      echo
      wget --quiet --show-progress --progress=dot:giga $dl_url
      echo
   fi

   echo
   echo "=== extracting $name.tar.gz ==="
   echo
   tar xvf $name.tar.gz

   echo
   echo "=== building $name ==="
   echo
   pushd $name

   TSS2_ESYS_2_3_CFLAGS="-I${TSS}/include" TSS2_ESYS_2_3_LIBS="-ltss2-esys -L$TSS/src/tss2-esys/.libs/" \
   TSS2_MU_CFLAGS="-I${TSS}/include" TSS2_MU_LIBS="-ltss2-mu -L$TSS/src/tss2-mu/.libs/" \
   TSS2_TCTILDR_CFLAGS="-I${TSS}/include" TSS2_TCTILDR_LIBS="-ltss2-tctildr -L$TSS/src/tss2-tcti/.libs/" \
   TSS2_RC_CFLAGS="-I${TSS}/include" TSS2_RC_LIBS="-ltss2-rc -L$TSS/src/tss2-rc/.libs/" \
   ./configure --prefix=/usr/local
   
   make
   append_installer
   popd
}

main