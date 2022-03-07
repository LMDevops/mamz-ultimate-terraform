variable "network_name" {
  type    = string
  default = "gemp-shared-base-vpc"
}

variable "project_name" {
  type    = string
  default = "gemp-bu1-project1"
}

variable "billing_account" {
  type    = string
  default = "01C805-AC04C5-836F50"
}

variable "monitoring_admin_roles" {
  description = "A list of roles to give the identity for the project"
  type        = list(string)
  default = [
    "roles/compute.viewer",
    "roles/monitoring.viewer",
    "roles/cloudasset.viewer"
  ]
}

variable "domain_name" {
  type    = string
  default = "sadasola.com"
}

variable "parent_folder" {
  type    = string
  default = ""
}
