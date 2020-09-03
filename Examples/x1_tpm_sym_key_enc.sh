#!/bin/bash

# create a primary context with an ECC key just because we can.  This defaults to a child of the ower heirarchy
tpm2_createprimary -G ecc --key-context primary_x1.ctx

# create generates a new AES key.
tpm2_create -C primary_x1.ctx -G aes -u pub_x1.key -r priv_x1.key

# load creates the key context for encryption/decryption
tpm2_load -C primary_x1.ctx -u pub_x1.key -r priv_x1.key -c x1.key.ctx

# create an initialization vector
tpm2_getrandom --output iv.x1.dat 16

# encrypt README.md
tpm2_encryptdecrypt --key-context x1.key.ctx --iv iv.x1.dat --output readme.x1.enc.dat README.md

# decrypt to readme.x1.txt
tpm2_encryptdecrypt --decrypt --key-context x1.key.ctx --iv iv.x1.dat --output readme.x1.txt readme.x1.enc.dat