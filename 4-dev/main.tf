module "app1_dev_project" {
  source          = "../modules/projects"
  name            = local.app1_project_name
  project_id      = local.app1_project_name
  services        = local.app1_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.Dev.name
  labels          = local.project_terraform_labels
}

module "app1_dev_admin_iam" {
  source      = "../modules/iam/projects-iam"
  project     = trimprefix(module.app1_dev_project.project_id, "projects/")
  admin_roles = local.admin_roles
}

module "app1_dev_developer_iam" {
  source      = "../modules/iam/projects-iam"
  project     = trimprefix(module.app1_dev_project.project_id, "projects/")
  admin_roles = local.developer_roles
}

module "app1_dev_devops_iam" {
  source      = "../modules/iam/projects-iam"
  project     = trimprefix(module.app1_dev_project.project_id, "projects/")
  admin_roles = local.devops_roles
}
