module "shared_vpc_host_project" {
  source          = "../modules/projects"
  name            = "prj-${local.environment}-${local.svpc_project_label}"
  project_id      = "prj-${local.environment}-${local.svpc_project_label}"
  services        = local.svpc_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.fldr-shared.name
  labels          = local.project_terraform_labels
  svpc_host       = true
}

module "svpc_network" {
  source = "../modules/network"

  project_id      = trimprefix(module.shared_vpc_host_project.project_id, "projects/")
  prefix          = "sb"
  environment     = local.environment
  vpc_type        = local.vpc_type
  network_configs = local.svpc__network_configs
  depends_on = [
    module.shared_vpc_host_project
  ]
}

module "logging_monitoring_project" {
  source          = "../modules/projects"
  name            = "prj-${local.environment}-${local.log_mon_project_label}"
  project_id      = "prj-${local.environment}-${local.log_mon_project_label}"
  services        = local.log_mon_service_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.fldr-shared.name
  labels          = local.project_terraform_labels
}

module "secrets_kms_project" {
  source          = "../modules/projects"
  name            = "prj-${local.environment}-${local.secrets_kms_project_label}"
  project_id      = "prj-${local.environment}-${local.secrets_kms_project_label}"
  services        = local.secrets_kms_apis
  billing_account = var.billing_account
  folder_id       = data.terraform_remote_state.organization.outputs.folders.fldr-shared.name
  labels          = local.project_terraform_labels
}

module "shared_billing_export" {
  source                    = "../modules/shared_billing_export"
  domain                    = "techjunkie4hire.com"
  log_mon_prj_id            = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  billing_admin_group_email = var.billing_admin_group_email
  dataset_name              = "bqds-${local.environment}-billing-data"
  dataset_id                = "bqds_${local.environment}_billing_data"
  depends_on = [
    module.logging_monitoring_project
  ]
}

module "org_vpc_flow_log_bucket" {
  source                   = "../modules/logging/logs-storage/cloud-log-bucket"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  bucket_id                = local.flow_log_bucket_id
  log_sink_writer_identity = module.org_vpc_flow_log_sink.writer_identity
  retention_days           = 183

}

module "org_vpc_flow_log_sink" {
  source               = "../modules/logging/logs-router"
  parent_resource_type = "organization"
  log_sink_name        = "ls-${local.environment}-vpc-flow-sink"
  parent_resource_id   = data.terraform_remote_state.bootstrap.outputs.organization_id
  filter              = "logName:(\"projects/${trimprefix(module.logging_monitoring_project.project_id, "projects/")}/logs/compute.googleapis.com%2Fvpc_flows\")"
  #filter               = "logName:(\"projects/prj-s-svpc-3084/logs/compute.googleapis.com%2Fvpc_flows\")"
  destination_uri      = module.org_vpc_flow_log_bucket.destination_uri

}
## This will make any groups added to the var.groups able to use networks on the shared vpc host ##
module "shared_vpc_iam_bindings" {
  source             = "../modules/iam/svpc-iam"
  groups             = var.network_user_groups
  network_project_id = module.shared_vpc_host_project.project_id
}

module "org_data_access" {
  source              = "../modules/logging/data-access"
}

module "org_data_access_log_bucket" {
  source                   = "../modules/logging/logs-storage/cloud-log-bucket"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  bucket_id                = local.data_access_log_bucket_id
  log_sink_writer_identity = module.org_data_access_log_sink.writer_identity
  retention_days           = 183

}

module "org_data_access_log_sink" {
  source               = "../modules/logging/logs-router"
  parent_resource_type = "organization"
  log_sink_name        = "ls-${local.environment}-data-access-sink"
  parent_resource_id   = data.terraform_remote_state.bootstrap.outputs.organization_id
  #filter              = "logName=\"projects/prj-83923-s-orbit-8935/logs/cloudaudit.googleapis.com%2Fdata_access\""
  filter               = "protoPayload.@type=\"type.googleapis.com/google.cloud.audit.AuditLog\""
  destination_uri      = module.org_data_access_log_bucket.destination_uri

}

module "org_firewall_log_bucket" {
  source                   = "../modules/logging/logs-storage/cloud-log-bucket"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  bucket_id                = local.firewall_log_bucket_id
  log_sink_writer_identity = module.org_firewall_log_sink.writer_identity
  retention_days           = 183

}

module "org_firewall_log_sink" {
  source               = "../modules/logging/logs-router"
  parent_resource_type = "organization"
  log_sink_name        = "ls-${local.environment}-firewall-rule-sink"
  parent_resource_id   = data.terraform_remote_state.bootstrap.outputs.organization_id
  filter               = "resource.type=\"gce_firewall_rule\""
  destination_uri      = module.org_firewall_log_bucket.destination_uri

}


/*
TODO: Automate billing alerts?
*/
# module "billing_alerts" {
#   source = "../modules/shared_billing_alerts"

#   billing_account = var.billing_account
#   budget          = var.budget
# }

/*
TODO: Restrict the use of prod subnets 
*/
resource "google_project_iam_binding" "log_sink_member" {
  project = "prj-s-log-mon-7973"
  #bucket = local.storage_bucket_name
  role    = "roles/logging.bucketWriter"
  members = [module.org_vpc_flow_log_sink.writer_identity, module.org_data_access_log_sink.writer_identity, module.org_firewall_log_sink.writer_identity]

}
resource "google_storage_bucket_iam_member" "vpc_flow_storage_sink_member" {
  bucket = local.vpc_flow_storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = module.org_vpc_flow_storage_sink.writer_identity
           
}

resource "google_storage_bucket_iam_member" "data_access_storage_sink_member" {
  bucket = local.data_access_storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = module.org_data_access_storage_sink.writer_identity
           
}

resource "google_storage_bucket_iam_member" "firewall_storage_sink_member" {
  bucket = local.firewall_storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = module.org_firewall_storage_sink.writer_identity
           
}
