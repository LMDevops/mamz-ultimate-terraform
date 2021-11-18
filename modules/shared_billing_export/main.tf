resource "google_bigquery_dataset" "billing-exports" {
  dataset_id    = var.dataset_id
  friendly_name = var.dataset_name
  description   = "Billing exports for ${var.domain}"
  location      = "US"
  project       = var.log_mon_prj_id

  access {
    role           = "OWNER"
    group_by_email = var.billing_admin_group_email
  }
  access {
    role          = "OWNER"
    user_by_email = "billing-export-bigquery@system.gserviceaccount.com"
  }
}
