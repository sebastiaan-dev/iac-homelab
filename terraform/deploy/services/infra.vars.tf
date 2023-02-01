#
# Docker infrastructure service configuration
#

# VM

variable "infra_vm_cpus" {
  type = string
}

variable "infra_vm_memory" {
  type = string
}

variable "infra_vm_disk_size" {
  type = string
}

variable "infra_vm_hostname" {
  type = string
}

variable "infra_vm_ipv4_address" {
  type = string
}

# Service

variable "traefik_debug" {
  type = bool
}

variable "traefik_dev" {
  type = bool
}
