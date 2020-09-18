#!/usr/bin/env bash

# This script will download compile and install the application and python language support for TPM2 software.
# This includes tpm2_pytss, tpm2-pkcs11, and (someday) tpm2-tss-engine

tpm2_pkcs11_ver="1.4.0"
tpm2_tss_engine_ver="1.0.1"

function main {

   sudo -v
   
   get_build_pkgs

   mkdir -p workspace2
   pushd workspace2

   # pytss is not a c++ project so it is unique
   get_pytss "https://github.com/tpm2-software/tpm2-pytss"

    # get and build tmp2-pkcs11
   pkcs11_pkg_name="tpm2-pkcs11-$tpm2_pkcs11_ver"
   pkcs11_dl_url="https://github.com/tpm2-software/tpm2-pkcs11/releases/download/$tpm2_pkcs11_ver/$pkcs11_pkg_name.tar.gz"
   get_release $pkcs11_pkg_name $pkcs11_dl_url

   build_component $pkcs11_pkg_name

   sudo -v

    # get and build tmp2-tss-engine for openssl
   engine_pkg_name="tpm2-tss-engine-$tpm2_tss_engine_ver"
   engine_dl_url="https://github.com/tpm2-software/tpm2-tss-engine/releases/download/v$tpm2_tss_engine_ver/$engine_pkg_name.tar.gz"
   get_release $engine_pkg_name $engine_dl_url

   #TODO build_component $engine_pkg_name

   popd
}

function get_build_pkgs {
   sudo apt -y update

   # dependencies for tpm2-pkcs11 => sqlite3 and libsqplite3-dev libyaml-dev
   # dependencies for pytss => git and python3-pip
   # dependencies for tss-engine =>  TBD???
   sudo apt -y install sqlite3 libsqlite3-dev libyaml-dev git python3-pip
}

function get_pytss {
   git clone --depth 1 --recurse-submodules $1
   
   cd tpm2-pytss
   python3 -m pip install -e .

   cd ..
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

main