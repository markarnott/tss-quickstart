#!/usr/bin/env bash

# test the tss stack by running some tpm commands

ps -aux | grep tpm


export TPM2TOOLS_TCTI="tabrmd:bus_name=com.intel.tss2.Tabrmd"

tpm2_getcap pcrs

tpm2_pcrread sha256:1

tpm2_getrandom 16 --hex


