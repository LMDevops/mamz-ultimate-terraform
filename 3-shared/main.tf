module "shared_billing_alerts" {
  source                = "../modules/shared_billing_alerts"

  billing_account       = data.terraform_remote_state.bootstrap.outputs.billing_account
  budget                = "1000"
}


# locals {
#   project_terraform_labels = {
#     user                   = var.user
#     owner                  = var.owner
#   }
#
#   service_apis = [
#     "admin.googleapis.com",
#     "cloudbilling.googleapis.com",
#     "cloudidentity.googleapis.com",
#     "cloudresourcemanager.googleapis.com",
#     "compute.googleapis.com",
#     "iam.googleapis.com",
#     "logging.googleapis.com",
#     "monitoring.googleapis.com",
#     "orgpolicy.googleapis.com",
#     "secretmanager.googleapis.com",
#     "servicenetworking.googleapis.com",
#     "serviceusage.googleapis.com",
#     "storage-api.googleapis.com",
#   ]
#
#   sec_logs_base      = "sec-logs-01-shared"
#   sec_logs_project   = "pr-${local.sec_logs_base}"
#   sec_images_base    = "sec-images-01-shared"
#   sec_images_project = "pr-${local.sec_images_base}"
#   obsr_log_base      = "obsr-log-01-prod"
#   obsr_log_project   = "pr-${local.obsr_log_base}"
#   net_shrd_base      = "net-shrd-01-hub"
#   net_shrd_project   = "pr-${local.net_shrd_base}"
#   sec_scrt_mngr_base = "scrt-mngr-01-shared"
#   sec_scrt_mngr_project   = "pr-${local.sec_scrt_mngr_base}"
# }
#
# resource "google_folder" "shared" {
#   display_name = "Shared"
#   parent       = "organizations/${var.organization_id}"
# }
#
# module "security_logs" {
#   source                = "../modules/projects"
#   name                  = local.sec_logs_project
#   project_id            = local.sec_logs_project
#   services              = local.service_apis
#   billing_account       = var.billing_account
#   folder_id             = google_folder.shared.name
#   labels                = local.project_terraform_labels
# }
#
# module "security_trusted_images" {
#   source                = "../modules/projects"
#   name                  = local.sec_images_project
#   project_id            = local.sec_images_project
#   services              = local.service_apis
#   billing_account       = var.billing_account
#   folder_id             = google_folder.shared.name
#   labels                = local.project_terraform_labels
# }
#
# module "security_secrets_manager" {
#   source                = "../modules/projects"
#   name                  = local.sec_scrt_mngr_project
#   project_id            = local.sec_scrt_mngr_project
#   services              = local.service_apis
#   billing_account       = var.billing_account
#   folder_id             = google_folder.shared.name
#   labels                = local.project_terraform_labels
# }
#
# module "observability_logs" {
#   source                = "../modules/projects"
#   name                  = local.obsr_log_project
#   project_id            = local.obsr_log_project
#   services              = local.service_apis
#   billing_account       = var.billing_account
#   folder_id             = google_folder.shared.name
#   labels                = local.project_terraform_labels
# }
#
# module "network_shared_hub" {
#   source                = "../modules/projects"
#   name                  = local.net_shrd_project
#   project_id            = local.net_shrd_project
#   services              = local.service_apis
#   billing_account       = var.billing_account
#   folder_id             = google_folder.shared.name
#   labels                = local.project_terraform_labels
# }
