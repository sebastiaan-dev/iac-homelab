# Select store to place VM
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = var.vsphere_datacenter
}

data "vsphere_content_library" "content_library" {
  name = var.vsphere_content_library
}

data "vsphere_content_library_item" "content_library_item" {
  name       = var.vsphere_content_library_ovf
  library_id = data.vsphere_content_library.content_library.id
  type       = "OVF"
}

# Select virtual network to place VM
data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = var.vsphere_datacenter
}

resource "vsphere_virtual_machine" "vm" {
  name                    = var.vm_name
  folder                  = var.vsphere_folder
  num_cpus                = var.vm_cpus
  memory                  = var.vm_memory
  firmware                = var.vm_firmware
  efi_secure_boot_enabled = var.vm_efi_secure_boot_enabled
  datastore_id            = data.vsphere_datastore.datastore.id
  resource_pool_id        = var.vsphere_resource_pool
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    size             = var.vm_disk_size
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.content_library_item.id
    customize {
      linux_options {
        host_name = var.vm_hostname
        domain    = var.vm_domain
      }
      network_interface {
        ipv4_address = var.vm_ipv4_address
        ipv4_netmask = var.vm_ipv4_netmask
      }

      ipv4_gateway    = var.vm_ipv4_gateway
      dns_suffix_list = var.vm_dns_suffix_list
      dns_server_list = var.vm_dns_server_list
    }
  }
  lifecycle {
    ignore_changes = [
      clone[0].template_uuid,
    ]
  }

  provisioner "remote-exec" {
    inline = ["echo Wait for SSH to become available.."]

    connection {
      type     = "ssh"
      user     = "sebastiaan"
      password = "1L$Z7K5Mh8nL"
      host     = var.vm_ipv4_address
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ansible -i ${var.vm_ipv4_address}, --private-key ansible.pk ${var.playbook_path} ${join(" ", var.playbook_arguments)}"
    environment = {
      ANSIBLE_CONFIG = "ansible/ansible.cfg"
    }
  }
}
