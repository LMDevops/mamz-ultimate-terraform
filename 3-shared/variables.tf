variable "billing_account" {}
variable "billing_admin_group_email" {}
variable "groups" {
  type = list(string)
}
variable "budget" {
  default = "1000"  
}
