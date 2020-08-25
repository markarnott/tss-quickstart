#!/bin/bash


tpm2_createprimary -G ecc --key-context primary_x1.ctx

tpm2_create -C primary_x1.ctx -G aes -u x1.pub -r x1.priv

tpm2_load -C primary_x1.ctx -u x1.pub -r x1.priv -c sym_cipher_key.ctx

tpm2_getrandom --output iv.dat 16

tpm2_encryptdecrypt --key-context sym_cipher_key.ctx --iv iv.dat --output readme.enc.dat ../README.md

tpm2_encryptdecrypt --decrypt --key-context sym_cipher_key.ctx --iv iv.dat --output readme.txt readme.enc.dat