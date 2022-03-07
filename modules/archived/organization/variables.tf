variable "allowed-key-projects" {
  type        = list(any)
  description = "List of projects allowed to create service account keys"
  default = [
    #  UPDATE WITH LIST OF ALLOWED PROJECTS
    #  "prj-comm-projectfoo-1234",
    #  "prj-comm-projectbar-1234"
  ]
}

variable "domain_name" {
  type    = string
  default = "sadasola.com"
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