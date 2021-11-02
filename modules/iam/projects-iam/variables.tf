variable "project_id" {

}
variable "admin_roles" {
  type    = list(string)
  default = []
}

variable "developer_roles" {
  type    = list(string)
  default = []
}
variable "devops_roles" {
  type    = list(string)
  default = []
}
variable "admin_group_name" {
  type    = string
  default = ""
}

variable "developer_group_name" {
  type    = string
  default = ""
}
variable "devops_group_name" {
  type    = string
  default = ""
}
