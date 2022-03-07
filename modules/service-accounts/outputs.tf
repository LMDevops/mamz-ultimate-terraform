
output "iam_email" {
  description = "Service account email (for single use)."
  value       = "serviceAccount:${google_service_account.service_accounts.email}"
}

output "project_roles" {
  value = google_project_iam_member.project_roles
}

output "service_accounts" {
  value = google_service_account.service_accounts
}
