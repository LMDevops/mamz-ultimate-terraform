variable "billing_account" {}
variable "billing_admin_group_email" {}
variable "network_user_groups" {
  type = list(string)
}
variable "budget" {
  default = "1000"
}
