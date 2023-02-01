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
  vsphere_resource_pool       = data.vsphere_resource_pool.resource_pool.id
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
