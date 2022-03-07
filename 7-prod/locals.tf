locals {
  env               = "p"
  app_name          = "app-change_me" # APP_CHANGE_ME - Limit to 6 characters
  business_code     = "bc-change_me"  # BC_CHANGE_ME  - Limit to 4-6 caracters
  app1_project_name = "prj-${local.business_code}-${local.env}-${local.app_name}"

  app1_service_apis = [
    "compute.googleapis.com"
  ]
  project_terraform_labels = {
    "env" = "prod"
  }

  admin_roles = [
    "roles/viewer"
  ]

  developer_roles = [
    "roles/compute.viewer",
    "roles/container.viewer",
    "roles/logging.viewer",
    "roles/dataproc.viewer",
    "roles/bigquery.dataViewer",
    "roles/bigquery.resourceViewer",
    "roles/cloudfunctions.viewer",
    "roles/monitoring.viewer"
  ]

  devops_roles = [
    "roles/compute.viewer",
    "roles/container.viewer",
    "roles/logging.viewer",
    "roles/dataproc.viewer",
    "roles/bigquery.dataViewer",
    "roles/bigquery.resourceViewer",
    "roles/cloudfunctions.viewer",
    "roles/monitoring.viewer"
  ]
}
