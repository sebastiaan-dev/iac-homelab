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

data "vsphere_datastore" "subscriber_datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_folder" "folder" {
  path = "${var.vsphere_datacenter}/vm/${var.vsphere_folder}"
}

# Select cluster in datacenter to place VM
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}
