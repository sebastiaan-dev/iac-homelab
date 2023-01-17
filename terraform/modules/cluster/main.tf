# resource "vsphere_compute_cluster" "compute_cluster" {
#   name            = var.vsphere_cluster
#   datacenter_id   = data.vsphere_datacenter.dc.id
#   folder          = var.vsphere_cluster_folder
#   host_system_ids = [data.vsphere_host.host.*.id]

#   drs_enabled          = true
#   drs_automation_level = "fullyAutomated"

#   ha_enabled = false
# }
