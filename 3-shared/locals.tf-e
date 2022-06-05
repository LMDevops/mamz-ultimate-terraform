locals {
  project_terraform_labels = {
    "env" = "shared"
  }

  log_mon_service_apis = [
    "bigquery.googleapis.com",
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]

  secrets_kms_apis = [
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com",
  ]

  svpc_service_apis = [
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "ids.googleapis.com",
  ]
  flow_log_bucket_id        = "bkt-s-log-mon-vpcflow"
  vpc_type                  = "shared"
  environment               = "s"
  business_code             = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  svpc_project_label        = "svpc"
  log_mon_project_label     = "log-mon"
  secrets_kms_project_label = "secrets-kms"
  svpc__network_config_path = "./config/networking"
  svpc__network_config_sets = fileset(local.svpc__network_config_path, "*.json")
  svpc__network_configs = flatten([for networks in local.svpc__network_config_sets : [
    for network in jsondecode(file("${local.svpc__network_config_path}/${networks}")) :
    merge(network, { fileName = split(".", networks)[0] })
  ]])
}
