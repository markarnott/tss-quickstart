# tss-quickstart
scripts to get started with development on the TCG software stack for TPM2

## Overview
The Trusted Computing Group is developing open software components called the TSS.  These components make it easier to develop applications that use TPM2.  These components are in active development and can be found at https://github.com/tpm2-software 

The scripts in this repository simplify the task of downloading, compiling and configuring new releases of the components that make up the TSS.

The build and install process includes two phases.  The first phase will build and install the TSS software up to tpm tools.  This includes the IBM TPM simulator, tpm2-tss, tpm2-abrmd and tmp2-tools.

Phase 1 is accomplished with scripts 1 to 5.  

The second phase includes application and higher language tools.  These are built and installed with script 6.
This includes python bindings in tpm2-pytss; the pcks#11 interface to the tpm in tpm2-pkcs11; and (someday) the openssl engine in tpm2-tss-engine. 

## Usage

Phase 1

> sudo ./1get_dependency_pkgs.sh
>
> ./2build_tpm2.sh | tee build.log
>
> sudo ./3install_tpm2.sh
>
> sudo ./4configure_tpm2.sh
>
> ./5start_tpm2.sh

Once phase 1 is complete, you must ensure that tpm2-tools are working properly.  

Phase 2

> ./6get_app_n_python_tools.sh


## Target Environment
These scripts have been tested on Ubuntu 20.04.  

They assume a clean virtual machine, and configure the system to use a TPM simulator.  Access to a physical or a virtual TPM is not required (and not recommended for early stages of development.)

This environment is intended for someone developing on top of the latest TSS components, but not for developing the TSS itself.  The builds do not include test suites or local documentation.




