/*
BILLING
*/
resource "google_organization_iam_member" "billing_admin_roles" {
  for_each = toset(var.billing_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-${var.client-short-name}-org-billing-admins@${var.domain}"
}
/*
NETWORK
*/
resource "google_organization_iam_member" "network_admin_roles" {
  for_each = toset(var.network_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-${var.client-short-name}-org-network-admins@${var.domain}"
}

/*
ORG ADMIN
*/
resource "google_organization_iam_member" "org_admin_roles" {
  for_each = toset(var.organization_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-${var.client-short-name}-org-organization-admins@${var.domain}"
}
/*
SECURITY
*/
resource "google_organization_iam_member" "security_admin_roles" {
  for_each = toset(var.security_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-${var.client-short-name}-org-security-admins@${var.domain}"
}
/*
AUDITOR
*/
resource "google_organization_iam_member" "auditor_roles" {
  for_each = toset(var.auditor_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-${var.client-short-name}-org-auditors@${var.domain}"
}
