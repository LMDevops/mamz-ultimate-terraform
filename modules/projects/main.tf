resource "random_id" "main" {
  byte_length = 2
}

locals {
  project_id = "${var.project_id}-${random_id.main.hex}"
}

resource "google_project" "main" {
  name                = var.name
  project_id          = local.project_id
  billing_account     = var.billing_account
  org_id              = var.org_id
  folder_id           = var.folder_id
  labels              = var.labels
  auto_create_network = var.auto_create_network
}

resource "google_project_service" "main" {
  for_each = toset(var.services)
  project  = google_project.main.id
  service  = each.value

  disable_dependent_services = var.disable_dependent_services
}

resource "google_project_iam_audit_config" "main_cis_feature_1" {
  count = var.enforce_cis_standards == true ? 1 : 0
  project = google_project.main.id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}