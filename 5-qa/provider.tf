terraform {
  backend "gcs" {
    bucket = "bkt-b-zzzz-tfstate-tfstate"
    prefix = "tf_state_qa"
  }
}

data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    bucket = "bkt-b-zzzz-tfstate-tfstate"
    prefix = "tf_state_organization"
  }
}

