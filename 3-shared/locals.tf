locals {
  project_terraform_labels = {
    "env" = "shared"
  }

  log_mon_service_apis = [
    "bigquery.googleapis.com",
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]

  svpc_service_apis = [
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
  ]

  sec_logs_base      = "sec-logs-01-shared"
  sec_logs_project   = "pr-${local.sec_logs_base}"
  sec_images_base    = "sec-images-01-shared"
  sec_images_project = "pr-${local.sec_images_base}"
  obsr_log_base      = "obsr-log-01-prod"
  obsr_log_project   = "pr-${local.obsr_log_base}"

  svpc_project_name     = "prj-zzzz-s-svpc"
  log_mon_project_name  = "prj-zzzz-s-log-mon"
  sec_scrt_mngr_base    = "scrt-mngr-01-shared"
  sec_scrt_mngr_project = "pr-${local.sec_scrt_mngr_base}"
  environment           = "s"
}
