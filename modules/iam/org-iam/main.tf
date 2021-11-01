/*
BILLING
*/
resource "google_organization_iam_member" "billing_admin_roles" {
  for_each = toset(var.billing_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-gcp-zzzz-org-p-billing-admin@${var.domain}"
}
/*
NETWORK
*/
resource "google_organization_iam_member" "network_admin_roles" {
  for_each = toset(var.network_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-gcp-zzzz-org-p-network-admin@${var.domain}"
}

/*
ORG ADMIN
*/
resource "google_organization_iam_member" "org_admin_roles" {
  for_each = toset(var.organization_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-gcp-zzzz-org-p-org-admin@${var.domain}"
}
/*
SECURITY
*/
resource "google_organization_iam_member" "security_admin_roles" {
  for_each = toset(var.security_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-gcp-zzzz-org-p-security-admin@${var.domain}"
}
/*
AUDITOR
*/
resource "google_organization_iam_member" "auditor_roles" {
  for_each = toset(var.auditor_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-gcp-zzzz-org-p-auditor@${var.domain}"
}
/*
SUPPORT
*/
resource "google_organization_iam_member" "support_admin_roles" {
  for_each = toset(var.support_admin_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "group:grp-gcp-zzzz-org-p-support-admin@${var.domain}"
}
