terraform {
  backend "gcs" {
    bucket = "bkt-b-zzzz-tfstate-tfstate"
    prefix = "tf_state_bootstrap"
  }
}
