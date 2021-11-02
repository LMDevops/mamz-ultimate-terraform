module "shared_vpc_host_project" {
  source          = "../modules/projects"
  name            = local.svpc_project_name
  project_id      = local.svpc_project_name
  services        = local.svpc_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.Shared.name
  labels          = local.project_terraform_labels
  svpc_host       = true
}

module "svpc_network" {
  source = "../modules/network"

  project_id      = trimprefix(module.shared_vpc_host_project.project_id, "projects/")
  prefix          = "sb"
  environment     = "s"
  network_configs = local.svpc__network_configs
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

module "org_vpc_flow_log_bucket" {
  source                   = "../modules/logging/logs-storage/cloud-log-bucket"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  bucket_id                = "bkt-s-zzzz-log-mon-vpcflow"
  log_sink_writer_identity = module.org_vpc_flow_log_sink.writer_identity
  retention_days           = 30
}

module "org_vpc_flow_log_sink" {
  source               = "../modules/logging/logs-router"
  parent_resource_type = "organization"
  log_sink_name        = "ls-s-zzzz-vpc-flow-sink"
  parent_resource_id   = data.terraform_remote_state.bootstrap.outputs.organization_id
  filter               = "logName:(\"projects/${trimprefix(module.logging_monitoring_project.project_id, "projects/")}/logs/compute.googleapis.com%2Fvpc_flows\")"
  destination_uri      = module.org_vpc_flow_log_bucket.destination_uri
}

module "shared_vpc_iam_bindings" {
  source             = "../modules/iam/svpc-iam"
  groups             = var.groups
  network_project_id = module.shared_vpc_host_project.project_id
}
