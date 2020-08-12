#!/bin/bash
# from https://github.com/keylime/keylime/blob/master/scripts/tpm_serverd

/usr/bin/pgrep -x "tpm_server" &> /dev/null
if [[ $? -eq 0 ]]; then   
   echo "tpm_server is already running, stop it first with pkill -x tpm_server"
   exit 1
fi

export TPM_PATH=~/.tpm0/

mkdir -p ${TPM_PATH}

pushd ${TPM_PATH}

touch tpm_server.log

echo "$(date) TPM Server Starting" >> tpm_server.log 

tpm_server >> tpm_server.log &

sleep 2

popd
