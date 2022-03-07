resource "google_organization_iam_member" "monitoring_admin_roles" {
  for_each = toset(var.monitoring_admin_roles)
  org_id   = data.google_organization.org.org_id
  role     = each.value
  member   = "group:gcp-devops@sadasola.com"
}