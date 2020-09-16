#!/usr/bin/env bash

# This script will install the required packages to build TPM2 software.
#  
# This script has been tested on Ubuntu 19.10 and 20.04.  

if [ "$EUID" -ne 0 ]
  then echo "This script requires root.  Call with sudo"
  exit
fi

function get_pkgs_4ubuntu {
   apt -y update

   apt -y install wget
   apt -y install autoconf autoconf-archive automake build-essential \
      gcc pkg-config

   apt -y install libtool libssl-dev libjson-c-dev libini-config-dev

   # we could optionally use libcurl4-gnutls-dev instead of openssl-dev
   apt -y install libcurl4-openssl-dev

   # required for abrmd
   apt -y install libglib2.0-dev

   # required for tpm2-tools
   apt -y install uuid-dev python-yaml
}

# TODO
# we could check the distro and call a different function for fedora
# looking for a volunteer with time and a test machine

get_pkgs_4ubuntu