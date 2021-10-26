terraform {
  backend "gcs" {
    prefix = "tf_state_shared"
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

data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    bucket = data.terraform_remote_state.bootstrap.outputs.bucket
    prefix = "tf_state_organization"
  }
}
