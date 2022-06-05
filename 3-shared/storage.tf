module "org_vpc_flow_storage_sink" {
  source                 = "../modules/logging/logs-router"
  destination_uri        = module.org_vpc_flow_storage_bucket.destination_uri
  filter                 = "logName:(\"projects/${trimprefix(module.logging_monitoring_project.project_id, "projects/")}/logs/compute.googleapis.com%2Fvpc_flows\")"
  log_sink_name          = "ls-${local.environment}-vpc-flow-sink"
  parent_resource_id     = data.terraform_remote_state.bootstrap.outputs.organization_id
  parent_resource_type   = "organization"
  unique_writer_identity = true
}

module "org_vpc_flow_storage_bucket" {
  source                   = "../modules/logging/logs-storage/storage"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  storage_bucket_name      = local.vpc_flow_storage_bucket_name
  log_sink_writer_identity = "module.org_vpc_flow_storage_sink.writer_identity"
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age        = 1825
        with_state = "ANY"
      }
    },
    {
      action = {
        type = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age        = 1825
        with_state = "ANY"
      }
    }
  ]
}

module "org_data_access_storage_sink" {
  source                 = "../modules/logging/logs-router"
  destination_uri        = module.org_data_access_storage_bucket.destination_uri
  filter                 = "protoPayload.@type=\"type.googleapis.com/google.cloud.audit.AuditLog\""
  log_sink_name          = "ls-${local.environment}-data-access-sink"
  parent_resource_id     = data.terraform_remote_state.bootstrap.outputs.organization_id
  parent_resource_type   = "organization"
  unique_writer_identity = true
}

module "org_data_access_storage_bucket" {
  source                   = "../modules/logging/logs-storage/storage"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  storage_bucket_name      = local.data_access_storage_bucket_name
  log_sink_writer_identity = "module.org_data_access_storage_sink.writer_identity"
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age        = 1825
        with_state = "ANY"
      }
    },
    {
      action = {
        type = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age        = 1825
        with_state = "ANY"
      }
    }
  ]
}

module "org_firewall_storage_sink" {
  source                 = "../modules/logging/logs-router"
  destination_uri        = module.org_firewall_storage_bucket.destination_uri
  filter                 = "resource.type=\"gce_firewall_rule\""
  log_sink_name          = "ls-${local.environment}-firewall-sink"
  parent_resource_id     = data.terraform_remote_state.bootstrap.outputs.organization_id
  parent_resource_type   = "organization"
  unique_writer_identity = true
}

module "org_firewall_storage_bucket" {
  source                   = "../modules/logging/logs-storage/storage"
  project_id               = trimprefix(module.logging_monitoring_project.project_id, "projects/")
  storage_bucket_name      = local.firewall_storage_bucket_name
  log_sink_writer_identity = "module.org_firewall_storage_sink.writer_identity"
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age        = 1825
        with_state = "ANY"
      }
    },
    {
      action = {
        type = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age        = 1825
        with_state = "ANY"
      }
    }
  ]
}

