resource "google_bigquery_dataset" "billing-exports" {
  dataset_id    = "${var.client-short-name}_billing_export"
  friendly_name = "${var.client-short-name}-billing-export"
  description   = "Billing exports for ${var.domain}"
  location      = "US"
  project       = data.terraform_remote_state.projects.outputs.monitoring-project

  access {
    role           = "OWNER"
    group_by_email = "${var.client-short-name}-billing-admins@${var.domain}"
  }
  access {
    role          = "OWNER"
    user_by_email = "billing-export-bigquery@system.gserviceaccount.com"
  }
}
