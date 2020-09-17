# tss-quickstart
scripts to get started with development on the TCG software stack for TPM2

## Overview
The Trusted Computing Group is developing open software components called the TSS.  These components make it easier to develop applications that use TPM2.  These components are in active development and can be found at https://github.com/tpm2-software 

The scripts in this repository simplify the task of downloading, compiling and configuring new releases of the components that make up the TSS.

The build and install process includes two phases.  The first phase will build and install the TSS software up to tpm tools.  This includes the IBM TPM simulator, tpm2-tss, tpm2-abrmd and tmp2-tools.

The second phase includes application tools and python language bindings.
This includes tpm2-pytss, tpm2-pkcs11; and (someday) the openssl engine in tpm2-tss-engine. 


## Usage

Phase 1

> ./1build_p1_tools.sh
>
> ./2start_tpm2.sh

Once phase 1 is complete, you must ensure that tpm2-tools are working properly.  

Phase 2

> ./3get_app_python_tools.sh


## Target Environment
These scripts have been tested on Ubuntu 20.04.  

They assume a clean virtual machine, and configure the system to use a TPM simulator.  Access to a physical or a virtual TPM is not required (and not recommended for early stages of development.)

This environment is intended for someone developing on top of the latest TSS components, but not for developing the TSS itself.  The builds do not include test suites or local documentation.




