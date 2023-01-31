# Infrastructure as Code repository

This repository contains code which automatically deploys services on the compute server. By defining the infrastructure with code we prevent configuration drift, as well as improve determinism and security.

This repository consists of 2 sections, Packer is responsible for building templates of machines and operating systems. These templates are then used by Terraform for deployment. In both the Packer and Terraform section are Ansible sections, these provide fine-grained machine configuration on the application level.

## Prerequisites

This repository is validated on macOS, no guarantee can be given for other systems. In order to run the scripts present in this repo you will need the below dependencies:

- Ansible
- Packer
- Terraform

This repository makes use of functionality from VMWare products, some of which are only accesible with a license. Make sure you have at least the following licenses on the host machines you are managing with Terraform:

- vCenter 7.0 Standard
- vSphere 7.0 Enterprise Plus

## Usage

Executing the below command will execute in 3 sequential steps. First it will configure the vCenter and vSphere instance such that VMs can be deployed in a cluster, as well as creating an OVF content library for the packer templates. Second packer will build the templates defined in the script in parallel and store them in the content library. Third is the deployment of the services which are defined in the script:

```sh
./deploy.sh
```

## Customization

### Templates

In order to change or add to the hardware configurations change or add files in the `packer/hardware` directory, then use these configurations in the deploy script in the root directory of the repository.

### Services

Adding, removing or changing the deployed services can be done by changing the files in the `terraform/services` directory, as well as the corresponding `.tfvars` service file in the `terraform/variables` directory. A service should be deployed using the ovf module defined in `terraform/deploy/modules/ovf`.

## Configuration

TODO: private key doc
TODO: change le server to production doc (prevents Coder certificate error)

## Limitations

- Manual configuration of ISO files, OVF library and OVF permissions is required.
- Packer and Terraform run as the root user.
- Ansible playbooks are not idempotent.

## Troubleshooting

### Terminal stuck on waiting for SSH connection

Packer takes around 15 minutes for most hardware configurations. When using smaller hardware configurations the process can take up around 30 minutes. If the process does not finish after the given time consider improving the hardware specifications of your templates.

### Unable to ssh into remote machine

You may see an error warning about a fingerprint not matching of the remote machine when trying to start an SSH session, to resolve this warning you can execute the following command:

```sh
ssh-keygen -f ~/.ssh/known_hosts -R <address-of-host-with-warning>
```
