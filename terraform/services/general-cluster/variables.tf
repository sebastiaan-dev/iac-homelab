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

variable "vsphere_cluster" {
  description = "Name for target cluster deployment"
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
