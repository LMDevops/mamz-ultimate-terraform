resource "google_folder" "bootstrap" {
  display_name = var.folder_display_name
  parent       = "organizations/${var.organization_id}"
}

module "bootstrap_seed" {
  source          = "../projects"
  name            = local.seed_project_display_name
  project_id      = local.seed_project_name
  billing_account = var.billing_account
  folder_id       = google_folder.bootstrap.name
  labels          = local.project_terraform_labels
  services        = local.proj_services_to_enable
}

module "bootstrap_automation_service_account" {
  source       = "../service-accounts"
  account_id   = local.sa_name
  display_name = "Service account for Terraform - created using Terraform"
  project      = trimprefix(module.bootstrap_seed.project_id, "projects/")
  role         = "roles/owner"
}

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = toset(local.tf_svc_acc_org_iam_roles)

  org_id = trimprefix(var.organization_id, "organizations/")
  role   = each.value
  member = module.bootstrap_automation_service_account.iam_email
}

module "bootstrap_automation_bucket" {
  source  = "../google-cloud-storage"
  project = trimprefix(module.bootstrap_seed.project_id, "projects/")
  name    = local.bucket_name
  member  = module.bootstrap_automation_service_account.iam_email
  labels  = local.project_terraform_labels
}
