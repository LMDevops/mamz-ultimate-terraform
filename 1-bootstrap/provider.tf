terraform {
  backend "gcs" {
    bucket = "bkt-b-tfstate-3518"
    prefix = "tf_state_bootstrap"
  }
}
