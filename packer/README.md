# Infrastructure as code

This repository contains the files which provide an outline for the infrastructure used by homelab.

## Prerequisite

You'll need the following licenses:

- vSphere 7 Enterprise Plus
- VMware vCenter Server 7 Standard

A configured installation of vSphere 7 with vCenter Server 7 should be available. Your deployment machine will also need Terraform and Packer from Hashicorp to be installed, as well as Ansible from RedHat.

TODO: content lib specifications
TODO: specific user for infrastructure deployment

## Configuration

All `pkrvars.hcl` extensions contain variables that may need to be changed depending on your environment requirements.

### vsphere.pkrvars.hcl

This file contains information that will be used to connect to the deployed machines.

TODO: best practice, recreate ssh keys for safety

### vsphere.pkrvars.hcl

This file contains variables necessary to connect to your vSphere and vCenter instances. It will further determine how it will be stored on the server.

TODO: create best practices setup for vsphere server

## Installation

Run the deploy script in the scripts directory as follows:

packer init ubuntu/22-10/.

```bash
./scripts/deploy.sh
```
