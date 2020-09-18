#!/usr/bin/env bash

# start the simulator #
/usr/bin/pgrep -x "tpm_server" &> /dev/null
if [[ $? -eq 1 ]]; then   
   mkdir -p ~/.tpm0/

   pushd ~/.tpm0/

   tpm_server &

   sleep 2

   popd
fi

# start the resource manager
sudo systemctl start tpm2-abrmd

# test the tss stack by running some tpm commands
export TPM2TOOLS_TCTI="tabrmd:bus_name=com.intel.tss2.Tabrmd"

tpm2_getcap pcrs

tpm2_pcrread sha256:1

tpm2_getrandom 16 --hex


