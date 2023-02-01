#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-b]

This script configures and deploys the Terraform codebase onto the defined infrastructure.

Available options:

-h, --help      Print this help and exit
-b, --build     Include build and upload of the Packer OVF templates
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  build=0

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -b | --build) build=1 ;; # example flag
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

parse_params "$@"

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

build_templates() {
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
    # Copy and concatenate service deployment variables into one file
    cat vcenter.tfvars vsphere.tfvars domain.tfvars coder.tfvars infra.tfvars vpn.tfvars > ../deploy/terraform.tfvars
    cd ..
    cd deploy/services
    # Copy and concatenate service deployment configuration into one file
    cat coder.tf infra.tf vpn.tf > ../services.tf
    # Copy and concatenate service required variable definitions into one file
    cat coder.vars.tf infra.vars.tf vpn.vars.tf > ../variables.services.tf
    cd ..

    terraform init
    terraform apply
}

(setup)
if [ $build == 1 ]
then
    (build_templates)
fi
(deploy)