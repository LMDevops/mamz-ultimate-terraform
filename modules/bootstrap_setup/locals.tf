resource "random_id" "main" {
  byte_length = 2
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
