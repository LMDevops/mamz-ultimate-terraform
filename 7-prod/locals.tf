locals {
  env               = "p"
  app1_project_name = "prj-zzzz-${local.env}-app1"

  app1_service_apis = [
    "compute.googleapis.com"
  ]
  project_terraform_labels = {
    "env" = "prod"
  }
}
