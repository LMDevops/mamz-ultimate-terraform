terraform {
  backend "gcs" {
    bucket = "bkt-b-tfstate-1623"
    prefix = "tf_state_organization"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider "google" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket = "bkt-b-tfstate-1623"
    prefix = "tf_state_bootstrap"
  }
}
