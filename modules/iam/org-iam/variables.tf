variable "org_id" {

}
variable "domain" {}

variable "billing_admin_group" { default = "" }
variable "org_admin_group" { default = "" }
variable "security_admin_group" { default = "" }
variable "network_admin_group" { default = "" }
variable "auditor_group" { default = "" }
variable "support_admin_group" {
  default = "" 
}
variable "billing_admin_roles" {
  description = "A list of roles to give billing admins"
  type        = list(string)
  default = [
    "roles/billing.admin"
  ]
}

variable "network_admin_roles" {
  description = "A list of roles to give to network admins"
  type        = list(string)
  default = [
    "roles/accesscontextmanager.policyReader",
    "roles/cloudsql.viewer",
    "roles/compute.orgFirewallPolicyUser",
    "roles/compute.instanceAdmin",
    "roles/compute.networkViewer",
    # "roles/storage.legacyBucketReader",
    "roles/compute.xpnAdmin",
    "roles/container.clusterViewer",
    "roles/dns.reader",
    # "roles/networkManagment.admin",
    "roles/servicenetworking.networksAdmin"
  ]
}

variable "organization_admin_roles" {
  description = "A list of roles to give org admins"
  type        = list(string)
  default = [
    "roles/billing.user",
    "roles/cloudsupport.admin",
    "roles/iam.organizationRoleAdmin",
    # "roles/iam.organizationPolicyAdmin",
    # "roles/resourceManager.folderAdmin",
    # "roles/resourceManager.projectCreator",
    "roles/securitycenter.admin",
    "roles/resourcemanager.organizationAdmin"
  ]
}

variable "auditor_roles" {
  description = "A list of roles to give org auditors"
  type        = list(string)
  default = [
    "roles/browser",
    "roles/iam.organizationRoleViewer",
    "roles/logging.viewer",
    "roles/resourcemanager.organizationViewer",
    "roles/serviceusage.serviceUsageViewer",
    "roles/viewer"
  ]
}

variable "security_admin_roles" {
  description = "A list of roles for security admins in the org"
  type        = list(string)
  default = [
    "roles/bigquery.resourceViewer",
    "roles/compute.viewer",
    "roles/container.viewer",
    "roles/iam.organizationRoleViewer",
    "roles/iam.securityReviewer",
    "roles/logging.privateLogViewer",
    "roles/accesscontextmanager.policyAdmin",
    "roles/accesscontextmanager.policyReader",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/securitycenter.admin",
    "roles/logging.viewer"
  ]
}

variable "support_admin_roles" {
  description = "A list of roles for support admins"
  type        = list(string)
  default = [
    "roles/cloudsupport.admin"
  ]
}
