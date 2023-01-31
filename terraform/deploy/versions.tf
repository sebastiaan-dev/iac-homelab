#
# Global Terraform configuration
#

terraform {
  required_version = ">= 1.3.5"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.2.0"
    }
  }
}
