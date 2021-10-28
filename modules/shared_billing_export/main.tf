resource "google_bigquery_dataset" "billing-exports" {
  dataset_id    = "corbo_billing_export"
  friendly_name = "corbo-billing-export"
  description   = "Billing exports for corbo.me"
  location      = "US"
  project       = data.terraform_remote_state.projects.outputs.monitoring-project

  access {
    role          = "OWNER"
    user_by_email = "corbolj@corbo.me"
  }
  access {
    role          = "OWNER"
    user_by_email = "google_service_account.bqowner.email"
  }
}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}
