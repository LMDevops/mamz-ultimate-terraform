resource "random_integer" "main" {
  min = 0001
  max = 9999
}

locals {
  project_id = "${var.project_id}-${random_integer.main.result}"
}

resource "google_compute_shared_vpc_service_project" "service_project" {
  count           = var.is_service_project ? 1 : 0
  host_project    = var.host_project_id
  service_project = google_project.main.project_id
  depends_on = [
    resource.google_compute_shared_vpc_host_project.host
  ]
}

resource "google_compute_shared_vpc_host_project" "host" {
  count   = var.svpc_host ? 1 : 0
  project = google_project.main.project_id
  depends_on = [
    resource.google_project_service.main
  ]
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
  count   = var.enforce_cis_standards == true ? 1 : 0
  project = google_project.main.id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}

resource "google_service_account" "service_account" {
  count        = var.has_sa ? 1 : 0
  account_id   = "${var.sa_account_id}-sa"
  display_name = "sa for ${var.sa_account_id}"
  project      = google_project.main.project_id
}
