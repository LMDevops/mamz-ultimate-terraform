module "shared_vpc_host_project" {
  source          = "../modules/projects"
  name            = local.svpc_project_name
  project_id      = local.svpc_project_name
  services        = local.svpc_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.Shared.name
  labels          = local.project_terraform_labels
}

module "logging_monitoring_project" {
  source          = "../modules/projects"
  name            = local.log_mon_project_name
  project_id      = local.log_mon_project_name
  services        = local.log_mon_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.Shared.name
  labels          = local.project_terraform_labels
}

module "shared_billing_export" {
  source                    = "../modules/shared_billing_export"
  domain                    = "example.com"
  log_mon_prj_id            = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  billing_admin_group_email = var.billing_admin_group_email
  dataset_name              = "bqds-${local.environment}-zzzz-billing-data"
  dataset_id                = "bqds_${local.environment}_zzzz_billing_data"
}
