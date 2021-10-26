output "bootstrap_automation_service_account" {
  value = module.bootstrap_setup.bootstrap_automation_service_account.service_accounts.email
  sensitive = true
}

output "bucket" {
  value =module.bootstrap_setup.bucket
}

output "organization_id" {
  value = var.organization_id
  sensitive = true
}

output "billing_account" {
  value = var.billing_account
  sensitive = true
}
