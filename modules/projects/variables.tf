variable "name" {
  type        = string
  description = "The name of the project"
}

variable "billing_account" {
  type        = string
  description = "The billing account ID for the project"
}

variable "project_id" {
  type        = string
  description = "The project id for the project. Only use if `var.random_suffix = false`"
  default     = null
}

variable "org_id" {
  type        = string
  description = "The numeric org id to create the project under. If set, the project will be created at the top level of the organization. Only one of `var.org_id` or `var.folder_id` can be set.  At least one must be set. If both are set, an error will occur."
  default     = null
}

variable "folder_id" {
  type        = string
  description = "The folder id to create the project under. Only one of `var.org_id` or `var.folder_id` may be set. At least one of them must be set. If both are set, an error will occur."
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "A key/value pair for labels to assign to the project"
  default     = {}
}


variable "auto_create_network" {
  type        = bool
  description = "Whether to keep the default network. Note that the default network will exist momentarily, so there must be room in the quota for at least one network."
  default     = false
}

variable "services" {
  type        = list(string)
  description = "A list of APIs (services) to enable"
  default     = ["compute.googleapis.com"]
}

variable "disable_dependent_services" {
  type        = bool
  description = "Whether to disable services that are dependent when a service is destroyed"
  default     = true
}

variable "enforce_cis_standards" {
  type        = bool
  description = "(optional) There will be additional features included that will conform to CIS standards - https://docs.bridgecrew.io/docs/google-cloud-policy-index"
  default     = true
}

variable "svpc_host" {
  type    = bool
  default = false
}

variable "is_service_project" {
  type    = bool
  default = false
}

variable "host_project_id" {
  type    = string
  default = null
}

variable "sa_account_id" {
  type    = string
  default = null
}
variable "has_sa" {
  type    = bool
  default = false
}
