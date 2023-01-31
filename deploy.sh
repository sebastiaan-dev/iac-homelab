#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  cd $script_dir
  rm terraform/setup/terraform.tfvars
  rm terraform/deploy/terraform.tfvars
}

#
# Script logic
#

setup () {
    cd terraform
    cd variables
    cat vcenter.tfvars vsphere.tfvars > ../setup/terraform.tfvars
    cd ../setup

    terraform init
    terraform apply

    cd ../..
}

build() {
    cd packer

    ./scripts/deploy.sh ubuntu 22-10 large &
    P1=$!
    ./scripts/deploy.sh ubuntu 22-10 medium &
    P2=$!
    ./scripts/deploy.sh ubuntu 22-10 tiny &
    P3=$!
    ./scripts/deploy.sh ubuntu 22-10 micro &
    P4=$!

    wait $P1 $P2 $P3 $P4
}

deploy () {
    cd terraform
    cd variables
    cat vcenter.tfvars vsphere.tfvars domain.tfvars coder.tfvars docker.tfvars vpn.tfvars > ../deploy/terraform.tfvars
    cd ..
    cd services
    cat coder.tf docker.tf vpn.tf > ../deploy/services.tf
    cd ../deploy

    terraform init
    terraform apply
}

(setup)
#(build)
(deploy)