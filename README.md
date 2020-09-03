# tss-quickstart
scripts to get started with development on the TCG software stack for TPM2

## Overview
The Trusted Computing Group is developing open software components called the TSS.  These components make it easier to develop applications that use TPM2.  These components are in active development and can be found at https://github.com/tpm2-software 

The scripts in this repository simplify the task of downloading, compiling and configuring new releases of the components that make up the TSS.

The build/installl process includes TSS, TPM Tools, ABRMD and the IBM TPM simulator.

## Target Environment
These scripts have been tested on Ubuntu 20.04.  

They assume a clean virtual machine, and configure the system to use a TPM simulator.  Access to a physical or a virtual TPM is not required (and not recommended for early stages of development.)

This environment is intended for someone developing on top of the latest TSS components, but not for developing the TSS itself.  The builds do not include test suites or local documentation.

## Usage

> sudo ./1get_build_tools.sh
>
> ./2build_tpm2.sh | tee build.log
>
> sudo ./3install_tpm2.sh
>
> sudo ./4configure_tpm2.sh
>
> ./5start_tpm2.sh


