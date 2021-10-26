resource "google_organization_policy" "restrict_public_ip_access_on_cloud_sql_instances" {
  org_id     = var.organization_id
  constraint = "sql.restrictPublicIp"

  boolean_policy {
    enforced = true
  }
}
