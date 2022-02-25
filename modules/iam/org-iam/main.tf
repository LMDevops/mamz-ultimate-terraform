/*
BILLING
*/
resource "google_organization_iam_member" "billing_admin_roles" {
  /* this resource will not be provisioned if the group name is not given */
  for_each = var.billing_admin_group != "" ? toset(var.billing_admin_roles) : []  
  org_id   = var.org_id
  role     = each.value
  member   = "group:${var.billing_admin_group}"
}
/*
NETWORK
*/
resource "google_organization_iam_member" "network_admin_roles" {
  /* this resource will not be provisioned if the group name is not given */
  for_each = var.network_admin_group != "" ? toset(var.network_admin_roles) : []  
  org_id   = var.org_id
  role     = each.value
  member   = "group:${var.network_admin_group}"
}

/*
ORG ADMIN
*/
resource "google_organization_iam_member" "org_admin_roles" {
  /* this resource will not be provisioned if the group name is not given */
  for_each = var.org_admin_group != "" ? toset(var.organization_admin_roles) : []   
  org_id   = var.org_id
  role     = each.value
  member   = "group:${var.org_admin_group}"
}
/*
SECURITY
*/
resource "google_organization_iam_member" "security_admin_roles" {
  /* this resource will not be provisioned if the group name is not given */
  for_each = var.security_admin_group != "" ? toset(var.organization_admin_roles) : []   
  org_id   = var.org_id
  role     = each.value
  member   = "group:${var.security_admin_group}"
}
/*
AUDITOR
*/
resource "google_organization_iam_member" "auditor_roles" {
  /* this resource will not be provisioned if the group name is not given */
  for_each = var.auditor_group != "" ? toset(var.auditor_roles) : []    
  org_id   = var.org_id
  role     = each.value
  member   = "group:${var.auditor_group}"
}
/*
SUPPORT
*/
resource "google_organization_iam_member" "support_admin_roles" {
  /* this resource will not be provisioned if the group name is not given */
  for_each = var.support_admin_group != "" ? toset(var.support_admin_roles) : []   
  org_id   = var.org_id
  role     = each.value
  member   = "group:${var.support_admin_group}"
}
