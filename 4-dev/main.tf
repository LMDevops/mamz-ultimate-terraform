module "app1_dev_project" {
  source          = "../modules/projects"
  name            = local.app1_project_name
  project_id      = local.app1_project_name
  services        = local.app1_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.Dev.name
  labels          = local.project_terraform_labels
  sa_account_id   = local.app1_project_name
  has_sa          = local.has_sa
}

module "app1_dev_admin_iam" {
  source           = "../modules/iam/projects-iam"
  project_id       = trimprefix(module.app1_dev_project.project_id, "projects/")
  admin_roles      = local.admin_roles
  admin_group_name = var.admin_group_name
}

module "app1_dev_developer_iam" {
  source               = "../modules/iam/projects-iam"
  project_id           = trimprefix(module.app1_dev_project.project_id, "projects/")
  developer_roles      = local.developer_roles
  developer_group_name = var.developer_group_name
}

module "app1_dev_devops_iam" {
  source            = "../modules/iam/projects-iam"
  project_id        = trimprefix(module.app1_dev_project.project_id, "projects/")
  devops_roles      = local.devops_roles
  devops_group_name = var.devops_group_name
}
