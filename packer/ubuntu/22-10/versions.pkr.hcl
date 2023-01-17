//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.8.5"

  required_plugins {
    git = {
      version = ">= 0.3.2"
      source  = "github.com/ethanmdavidson/git"
    }

    vsphere = {
      version = ">= v1.1.1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}