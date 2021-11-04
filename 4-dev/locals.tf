locals {
  env               = "d"
  app1_project_name = "prj-zzzz-${local.env}-app1"

  app1_service_apis = [
    "compute.googleapis.com"
  ]
  project_terraform_labels = {
    "env" = "dev"
  }

  admin_roles = [
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.objectAdmin"
  ]

  developer_roles = [
    "roles/editor",
    "roles/storage.objectAdmin"
  ]

  devops_roles = [
    "roles/editor",
    "roles/storage.objectAdmin"
  ]

  has_sa = true

}
