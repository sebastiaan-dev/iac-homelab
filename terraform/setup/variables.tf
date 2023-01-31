#
# Credentials
#

variable "vsphere_vcenter_server" {
  description = "Server location, should be FQDN"
  type        = string
}

variable "vsphere_user" {
  description = "Username for vSphere"
  type        = string
}

variable "vsphere_password" {
  description = "Password for vSphere"
  type        = string
  sensitive   = true
}

variable "vsphere_unverified_ssl" {
  description = "Accept self signed certificates"
  type        = bool
}

#
# vSphere target configuration
#

variable "hosts" {
  description = "Hosts to be included into the cluster"
  type        = list(string)
}

variable "vsphere_folder" {
  description = "Folder used to store VM related data"
  type        = string
}

variable "vsphere_datacenter" {
  description = "Datacenter used to deploy infrastructure"
  type        = string
}

variable "vsphere_datastore" {
  description = "Storage solution consumed infrastructure"
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
