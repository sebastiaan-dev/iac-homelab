# Infrastructure as Code repository

This repository contains code which automatically deploys services on the compute server. By defining the infrastructure with code we prevent configuration drift, as well as improve determinism and security.

This repository consists of 2 sections, Packer is responsible for building templates of machines and operating systems. These templates are then used by Terraform for deployment. In both the Packer and Terraform section are Ansible sections, these provide fine-grained machine configuration on the application level.

## Prerequisite

This repository is validated on macOS, no guarantee can be given for other systems. In order to run the scripts present in this repo you will need the below dependencies:

- Ansible
- Packer
- Terraform

TODO: private key doc
TODO: change le server to production doc (prevents Coder certificate error)

## Packer

## Terraform

## Limitations

- Manual configuration of ISO files, OVF library and OVF permissions is required.
- Packer and Terraform run as the root user.
- Ansible playbooks are not idempotent.
- Micro hardware configuration fails to build with Packer, Ubuntu is too heavy for specs.
- Redirection from http to https and domains with www prefix are not supported.

## Troubleshooting

### Unable to ssh into remote machine

You may see an error warning about a fingerprint not matching of the remote machine, to resolve this warning you can execute the following command:

```sh
ssh-keygen -f ~/.ssh/known_hosts -R <address-of-host-with-warning>
```
