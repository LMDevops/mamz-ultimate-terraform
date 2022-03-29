resource "random_integer" "main" {
  min = 0001
  max = 9999
}

locals {
  project_terraform_labels = var.labels

  proj_services_to_enable = [
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "billingbudgets.googleapis.com",
  ]

  tf_svc_acc_org_iam_roles = [
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/storage.admin",
    "roles/logging.configWriter",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.organizationViewer",
    "roles/browser",
    "roles/orgpolicy.policyAdmin"
  ]

  resource_base_name         = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  environment                = "b"
  seed_project_label         = "tfseed"
  seed_project_display_name  = "prj-${local.environment}-${local.seed_project_label}"
  seed_project_name          = "prj-${local.environment}-${local.seed_project_label}"
  state_project_label        = "tfstate"
  state_project_display_name = "prj-${local.environment}-${local.state_project_label}"
  state_project_name         = "prj-${local.environment}-${local.state_project_label}"
  bucket_name                = "bkt-${local.environment}-${local.state_project_label}-${random_integer.main.result}"
  sa_name                    = "sa-${local.environment}-${local.seed_project_label}-tf"
}
