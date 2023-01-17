# Select cluster in datacenter to place VM
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = var.vsphere_datacenter
}

resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.vsphere_resource_pool
  parent_resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
}

module "coder" {
  source = "../../modules/ovf"

  vsphere_datacenter          = var.vsphere_datacenter
  vsphere_datastore           = var.vsphere_datastore
  vsphere_folder              = var.vsphere_folder
  vsphere_resource_pool       = vsphere_resource_pool.resource_pool.id
  vsphere_network             = var.vsphere_network
  vsphere_content_library     = var.vsphere_content_library
  vsphere_content_library_ovf = "linux-ubuntu-22.04-lts-main-8C-16384RAM-102400DISK"

  vm_name                    = "coder-workspaces"
  vm_cpus                    = 8
  vm_memory                  = 16384
  vm_disk_size               = 102400 / 1024
  vm_firmware                = "efi"
  vm_efi_secure_boot_enabled = false
  vm_hostname                = "coder-workspaces"
  vm_domain                  = ""
  vm_ipv4_address            = "192.168.178.80"
  vm_ipv4_netmask            = "24"
  vm_ipv4_gateway            = "192.168.178.1"
  vm_dns_suffix_list         = []
  vm_dns_server_list         = ["8.8.8.8", "8.8.4.4"]

  playbook_path = "./ansible/coder.yml"
}

module "docker-infra" {
  source = "../../modules/ovf"

  vsphere_datacenter          = var.vsphere_datacenter
  vsphere_datastore           = var.vsphere_datastore
  vsphere_folder              = var.vsphere_folder
  vsphere_resource_pool       = vsphere_resource_pool.resource_pool.id
  vsphere_network             = var.vsphere_network
  vsphere_content_library     = var.vsphere_content_library
  vsphere_content_library_ovf = "linux-ubuntu-22.04-lts-main-2C-2048RAM-10240DISK"

  vm_name                    = "docker-infra"
  vm_cpus                    = 2
  vm_memory                  = 2048
  vm_disk_size               = 10240 / 1024
  vm_firmware                = "efi"
  vm_efi_secure_boot_enabled = false
  vm_hostname                = "docker-infra"
  vm_domain                  = ""
  vm_ipv4_address            = "192.168.178.81"
  vm_ipv4_netmask            = "24"
  vm_ipv4_gateway            = "192.168.178.1"
  vm_dns_suffix_list         = []
  vm_dns_server_list         = ["8.8.8.8", "8.8.4.4"]

  playbook_path = "./ansible/docker-infra.yml"
}
