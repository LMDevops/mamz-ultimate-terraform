variable "billing_account" {}
variable "billing_admin_group_email" {}
variable "groups" {
  type = list(string)
}
variable "svpc_project_name" {}
variable "log_mon_project_name" {}

