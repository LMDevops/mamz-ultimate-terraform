data "terraform_remote_state" "projects" {
  backend = "gcs"
  config = {
    bucket = ""
    prefix = ""
  }
}
