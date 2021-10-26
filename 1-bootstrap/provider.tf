
terraform {
  backend "gcs" {
    prefix = "tf_state_bootstrap"
  }
}
