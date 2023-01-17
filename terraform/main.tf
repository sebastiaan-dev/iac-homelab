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

module "general-cluster" {
  source = "./services/general-cluster"

  vsphere_folder          = vsphere_folder.folder.path
  vsphere_cluster         = var.vsphere_cluster
  vsphere_resource_pool   = var.vsphere_resource_pool
  vsphere_datacenter      = data.vsphere_datacenter.dc.id
  vsphere_datastore       = "fast-datastore"
  vsphere_network         = "VM Network"
  vsphere_content_library = "packer-templates"
}
