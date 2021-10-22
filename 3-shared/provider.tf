terraform {
  backend "gcs" {
    bucket = "sb-auto-tf-01-bootstrap-a384"
    prefix = "tf_state_shared"
  }
}

provider "google" {
  impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
  #impersonate_service_account = "sa-auto-tf-01-bootstrap@pr-auto-tf-01-bootstrap-0698.iam.gserviceaccount.com"
}

output "impersonate" {
  value = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket = "sb-auto-tf-01-bootstrap-a384"
    prefix = "tf_state_bootstrap"
  }
}
