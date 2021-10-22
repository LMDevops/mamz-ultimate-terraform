output "organization" {
  value = "organizations/${var.organization_id}"
}

# output "bootstrap_folder" {
#   value = google_folder.bootstrap
# }
#
# output "bootstrap_automation_project" {
#   value =module.bootstrap_automation
# }

output "bootstrap_automation_service_account" {
  value = module.bootstrap_automation_service_account.service_accounts.email
}
#bootstrap_automation_bucket
output "bucket" {
  value =module.bootstrap_automation_bucket.name
}

# data "google_service_account_access_token" "default" {
#   target_service_account = "sa-auto-tf-01-bootstrap@pr-auto-tf-01-bootstrap-0698.iam.gserviceaccount.com"
#   scopes = ["cloud-platform"]
# }
#
# output "token" {
#   value =data.google_service_account_access_token.default
# }
