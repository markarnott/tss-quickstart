#!/usr/bin/env bash

# post installation steps to configure the stack to call the tpm simulator

if [ "$EUID" -ne 0 ]
  then echo "This script requires root.  Call with sudo"
  exit
fi

ldconfig

useradd --system --user-group tss

# configure abrmd service to call the simulator instead of physical hardware
sed -i "s/ConditionPath/#ConditionPath/; s/tpm2-abrmd$/tpm2-abrmd --tcti=mssim/" /usr/local/lib/systemd/system/tpm2-abrmd.service

systemctl enable tpm2-abrmd
systemctl daemon-reload

pkill -HUP dbus-daemon

./tmp_serverd.sh
systemctl start tpm2-abrmd

