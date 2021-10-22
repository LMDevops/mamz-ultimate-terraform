locals {
  rolecount = var.role != null ? 1 : 0
}

  # module.core_automation_service_account.google_project_iam_member.project-roles["gc-sa-tf-pr-gcp-medx-auto-tf-01-2d0d=>roles/owner"] will be created
  resource "google_project_iam_member" "project_roles" {
      count = local.rolecount
      project = var.project
      role    = var.role
      member  = "serviceAccount:${google_service_account.service_accounts.email}"
  }

  # module.core_automation_service_account.google_service_account.service_accounts["gc-sa-tf-pr"] will be created
  resource "google_service_account" "service_accounts" {
      account_id   = var.account_id
      display_name = var.display_name
      project      = var.project
  }
  # 
  # resource "google_service_account_key" "service_accounts" {
  #   service_account_id = google_service_account.service_accounts.name
  # }
