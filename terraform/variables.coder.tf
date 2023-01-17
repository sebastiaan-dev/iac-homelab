#
# Coder service configuration
#

# VM

variable "coder_vm_cpus" {
  type = string
}

variable "coder_vm_memory" {
  type = string
}

variable "coder_vm_disk_size" {
  type = string
}

variable "coder_vm_hostname" {
  type = string
}

variable "coder_vm_ipv4_address" {
  type = string
}

# Service

variable "coder_subdomain" {
  type = string
}

variable "coder_oidc_issuer_url" {
  type = string
}

variable "coder_oidc_client_id" {
  type = string
}

variable "coder_oidc_client_secret" {
  type = string
}

variable "coder_experimental" {
  type = bool
}

variable "coder_first_user_username" {
  type = string
}

variable "coder_first_user_email" {
  type = string
}

variable "coder_first_user_password" {
  type = string
}

variable "coder_first_user_trial" {
  type = string
}
