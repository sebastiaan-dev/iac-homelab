# Infrastructure as Code repository

This repository contains code which automatically deploys services on the compute server. By defining the infrastructure with code we prevent configuration drift, as well as improve determinism and security.

This repository consists of 2 sections, Packer is responsible for building templates of machines and operating systems. These templates are then used by Terraform for deployment. In both the Packer and Terraform section are Ansible sections, these provide fine-grained machine configuration on the application level.

ssh-keygen -f ~/.ssh/known_hosts -R 192.168.178.80

## Packer

## Terraform