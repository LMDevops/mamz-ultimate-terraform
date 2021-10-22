resource "random_id" "main" {
  byte_length = 2
}

locals {

  project_terraform_labels = {
    user                   = "lcorbo"
    owner                  = "lcorbosada"
  }

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
  ]

  tf_svc_acc_org_iam_roles = [
      "roles/billing.admin",
      "roles/billing.user",
      "roles/compute.networkAdmin",
      "roles/compute.xpnAdmin",
      "roles/iam.securityAdmin",
      "roles/storage.admin",
      "roles/iam.serviceAccountAdmin",
      "roles/logging.configWriter",
      "roles/orgpolicy.policyAdmin",
      "roles/resourcemanager.folderAdmin",
      "roles/resourcemanager.projectCreator",
      "roles/resourcemanager.projectIamAdmin",
      "roles/resourcemanager.organizationViewer",
      "roles/browser",
      "roles/orgpolicy.policyAdmin",
      "roles/iam.serviceAccountTokenCreator"

  ]
  resource_base_name   = "auto-tf-01-bootstrap"
  project_display_name = "Organization Automation"
  project_name         = "pr-${local.resource_base_name}"
  bucket_name          = "sb-${local.resource_base_name}-${random_id.main.hex}"
  sa_name              = "sa-${local.resource_base_name}"
}

resource "google_folder" "bootstrap" {
  display_name = "Bootstrap"
  parent       = "organizations/${var.organization_id}"
}

module "bootstrap_automation" {
  source                = "../modules/projects"
  name                  = local.project_display_name
  project_id            = local.project_name
  billing_account       = var.billing_account
  folder_id             = google_folder.bootstrap.name
  labels                = local.project_terraform_labels
  services              = local.proj_services_to_enable
}

module "bootstrap_automation_service_account" {
  source       = "../modules/service-accounts"
  account_id   = local.sa_name
  display_name = "Service account for Terraform - created using Terraform"
  project      = trimprefix(module.bootstrap_automation.project_id,"projects/")
  role         = "roles/owner"
}

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = toset(local.tf_svc_acc_org_iam_roles)

  org_id   = trimprefix(var.organization_id, "organizations/")
  role     = each.value
  member   = module.bootstrap_automation_service_account.iam_email
}

module "bootstrap_automation_bucket" {
  source  = "../modules/google-cloud-storage"
  project = trimprefix(module.bootstrap_automation.project_id,"projects/")
  name    = local.bucket_name
  member  = module.bootstrap_automation_service_account.iam_email
  labels  = local.project_terraform_labels
}
