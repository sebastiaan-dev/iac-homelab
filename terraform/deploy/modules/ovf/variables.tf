#
# vSphere target configuration
#

variable "vsphere_datacenter" {
  description = "Datacenter used to deploy infrastructure dot"
  type        = string
}

variable "vsphere_datastore" {
  description = "Storage solution consumed infrastructure"
  type        = string
}

variable "vsphere_folder" {
  description = "Folder used to store VM related data"
  type        = string
}

variable "vsphere_resource_pool" {
  description = "Name for target resource pool in cluster"
  type        = string
}

variable "vsphere_network" {
  description = "Network used by deployed infrastructure"
  type        = string
}

variable "vsphere_content_library" {
  description = "Content library which contains OVF"
  type        = string
}

variable "vsphere_content_library_ovf" {
  description = "OVF name"
  type        = string
}

#
# Virtual Machine Settings
#

variable "vm_name" {
  type = string
}

variable "vm_cpus" {
  type = string
}

variable "vm_memory" {
  type = string
}

variable "vm_disk_size" {
  type = string
}

variable "vm_firmware" {
  type = string
}

variable "vm_efi_secure_boot_enabled" {
  type = bool
}

variable "vm_hostname" {
  type = string
}

variable "vm_domain" {
  type = string
}

variable "vm_ipv4_address" {
  type = string
}

variable "vm_ipv4_netmask" {
  type = string
}

variable "vm_ipv4_gateway" {
  type = string
}

variable "vm_dns_suffix_list" {
  type = list(string)
}

variable "vm_dns_server_list" {
  type = list(string)
}

#
# Ansible configuration
#

variable "playbook_path" {
  type = string
}

variable "playbook_arguments" {
  type = list(string)
}
