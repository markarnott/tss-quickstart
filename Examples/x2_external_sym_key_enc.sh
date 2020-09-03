#!/bin/bash

# create a primary context with an RSA key because import requires RSA.  This defaults to a child of the ower heirarchy
tpm2_createprimary -G rsa --key-context primary_x2.ctx

# use the tpm to create 128 bits of random data that we will use as an AES key.  
# this is just for demo purposes and should not be left on the file system.
tpm2_getrandom --output openaes.key 16

# import wraps the external generated key with the keys created in step 1
tpm2_import -C primary_x2.ctx -G aes -i openaes.key --private priv_x2.key --public pub_x2.key

# load creates the key context for encryption/decryption
tpm2_load --parent-context primary_x2.ctx --public pub_x2.key --private priv_x2.key --key-context x2.sym_cipher_key.ctx

# create an initialization vector
tpm2_getrandom --output iv.x2.dat 16

# encrypt README.md
tpm2_encryptdecrypt --key-context x2.sym_cipher_key.ctx --iv iv.x2.dat --output readme.x2.enc.dat README.md

# decrypt to readme.x2.txt
tpm2_encryptdecrypt --decrypt --key-context x2.sym_cipher_key.ctx --iv iv.x2.dat --output readme.x2.txt readme.x2.enc.dat
