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
  vsphere_resource_pool       = data.vsphere_resource_pool.resource_pool.id
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
