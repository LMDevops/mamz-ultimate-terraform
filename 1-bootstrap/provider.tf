terraform {
  backend "gcs" {
    bucket = "bkt-b-tfstate-1623"
    prefix = "tf_state_bootstrap"
  }
}
