locals {
  env               = "p"
  app1_project_name = "prj-zzzz-${local.env}-app1"

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
    "roles/monitoring.viewer",
    "roles/storage.legacyBucketReader"
  ]

  devops_roles = [
    "roles/compute.viewer",
    "roles/container.viewer",
    "roles/logging.viewer",
    "roles/dataproc.viewer",
    "roles/bigquery.dataViewer",
    "roles/bigquery.resourceViewer",
    "roles/cloudfunctions.viewer",
    "roles/monitoring.viewer",
    "roles/storage.legacyBucketReader"
  ]
}
