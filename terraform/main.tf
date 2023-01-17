#
# vSphere/vCenter configuration
#

# Connect to vCenter instance
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_vcenter_server
  allow_unverified_ssl = var.vsphere_unverified_ssl
}

# Select datacenter within vCenter (vSphere instance)
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_host" "host" {
  count         = length(var.hosts)
  name          = var.hosts[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "folder" {
  path          = var.vsphere_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Select cluster in datacenter to place VM
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.vsphere_resource_pool
  parent_resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
}

#
# Coder service configuration
#

locals {
  coder_access_url   = "${var.coder_subdomain}.${var.public_domain}"
  coder_wildcard_url = "*.${var.coder_subdomain}.${var.public_domain}"
  coder_ovf          = "linux-ubuntu-22.04-lts-main-${var.coder_vm_cpus}C-${var.coder_vm_memory}RAM-${var.coder_vm_disk_size}DISK"
}

module "coder" {
  source = "./modules/ovf"

  vsphere_datacenter          = data.vsphere_datacenter.dc.id
  vsphere_datastore           = var.vsphere_datastore
  vsphere_folder              = var.vsphere_folder
  vsphere_resource_pool       = vsphere_resource_pool.resource_pool.id
  vsphere_network             = var.vsphere_network
  vsphere_content_library     = var.vsphere_content_library
  vsphere_content_library_ovf = local.coder_ovf

  vm_name                    = var.coder_vm_hostname
  vm_cpus                    = var.coder_vm_cpus
  vm_memory                  = var.coder_vm_memory
  vm_disk_size               = var.coder_vm_disk_size / 1024
  vm_firmware                = "efi"
  vm_efi_secure_boot_enabled = false
  vm_hostname                = var.coder_vm_hostname
  vm_domain                  = ""
  vm_ipv4_address            = var.coder_vm_ipv4_address
  vm_ipv4_netmask            = var.internal_ipv4_netmask
  vm_ipv4_gateway            = var.internal_ipv4_gateway
  vm_dns_suffix_list         = var.internal_dns_suffix_list
  vm_dns_server_list         = var.internal_dns_server_list

  playbook_path = "./ansible/coder.yml"
  playbook_arguments = [
    "--extra-vars", "'CODER_ACCESS_URL=${local.coder_access_url}'",
    "--extra-vars", "'CODER_WILDCARD_ACCESS_URL=${local.coder_wildcard_url}'",
    "--extra-vars", "'CODER_OIDC_ISSUER_URL=${var.coder_oidc_issuer_url}'",
    "--extra-vars", "'CODER_OIDC_CLIENT_ID=${var.coder_oidc_client_id}'",
    "--extra-vars", "'CODER_OIDC_CLIENT_SECRET=${var.coder_oidc_client_secret}'",
    "--extra-vars", "'CODER_EXPERIMENTAL=${var.coder_experimental}'",
    "--extra-vars", "'CODER_FIRST_USER_USERNAME=${var.coder_first_user_username}'",
    "--extra-vars", "'CODER_FIRST_USER_EMAIL=${var.coder_first_user_email}'",
    "--extra-vars", "'CODER_FIRST_USER_PASSWORD=${var.coder_first_user_password}'",
    "--extra-vars", "'CODER_FIRST_USER_TRIAL=${var.coder_first_user_trial}'",
  ]
}

#
# Docker infrastructure service configuration
#

locals {
  infra_ovf = "linux-ubuntu-22.04-lts-main-${var.infra_vm_cpus}C-${var.infra_vm_memory}RAM-${var.infra_vm_disk_size}DISK"
}

module "docker-infra" {
  source = "./modules/ovf"

  vsphere_datacenter          = data.vsphere_datacenter.dc.id
  vsphere_datastore           = var.vsphere_datastore
  vsphere_folder              = var.vsphere_folder
  vsphere_resource_pool       = vsphere_resource_pool.resource_pool.id
  vsphere_network             = var.vsphere_network
  vsphere_content_library     = var.vsphere_content_library
  vsphere_content_library_ovf = local.infra_ovf

  vm_name                    = var.infra_vm_hostname
  vm_cpus                    = var.infra_vm_cpus
  vm_memory                  = var.infra_vm_memory
  vm_disk_size               = var.infra_vm_disk_size / 1024
  vm_firmware                = "efi"
  vm_efi_secure_boot_enabled = false
  vm_hostname                = var.infra_vm_hostname
  vm_domain                  = ""
  vm_ipv4_address            = var.infra_vm_ipv4_address
  vm_ipv4_netmask            = var.internal_ipv4_netmask
  vm_ipv4_gateway            = var.internal_ipv4_gateway
  vm_dns_suffix_list         = var.internal_dns_suffix_list
  vm_dns_server_list         = var.internal_dns_server_list

  playbook_path = "./ansible/docker-infra.yml"
  playbook_arguments = [
    "--extra-vars", "'CONTACT_INFO=${var.public_email}'",
    "--extra-vars", "'DOMAIN=${var.public_domain}'",
    "--extra-vars", "'CODER_SUBDOMAIN=${var.coder_subdomain}'",
    "--extra-vars", "'CODER_SERVER=${var.coder_vm_ipv4_address}:7080'",
  ]
}
