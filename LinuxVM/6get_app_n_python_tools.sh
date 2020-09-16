#!/usr/bin/env bash

# This script will download compile and install the application and python language support for TPM2 software.
# This includes tpm2_pytss, tpm2-pkcs11, and (someday) tpm2-tss-engine

tpm2_pkcs11_ver="1.4.0"
#tpm2_tss_engine_ver="1.0.1"

function main {
   get_build_pkgs

   get_pytss

   get_pkcs11 $tpm2_pkcs11_ver

   #TODO get_tss_engine $tpm2_tss_engine_ver
}

function get_build_pkgs {
   sudo apt -y update

   # dependencies for tpm2-pkcs11 => sqlite3 and libsqplite3-dev
   # dependencies for pytss => git and python3-pip
   sudo apt -y install sqlite3 libsqlite3-dev git python3-pip
}

function get_pytss {

   git clone --depth 1 --recurse-submodules https://github.com/tpm2-software/tpm2-pytss
   cd tpm2-pytss
   python3 -m pip install -e .
}

function get_pkcs11 {
   file_version=$1

   name="tpm2-pkcs11-$file_version"
   if [ ! -f "$name.tar.gz" ]; then
      dl_url="https://github.com/tpm2-software/tpm2-pkcs11/releases/download/$file_version/$name.tar.gz"
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
   echo "=== building $name  ==="
   echo
   pushd $name

   configure
   make
   sudo make install | tee install.log

   popd
}

main