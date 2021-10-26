terraform {
  backend "gcs" {
    prefix = "tf_state_organization"
  }
}

provider "google" {
  impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket = var.bucket
    prefix = "tf_state_bootstrap"
  }
}
