resource "google_organization_iam_audit_config" "org_config" {
  for_each = toset(local.audit_log_service)
  org_id  = "150390553932"
  service = each.value
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
    
  }
  audit_log_config {
    log_type = "ADMIN_READ"
  }
}