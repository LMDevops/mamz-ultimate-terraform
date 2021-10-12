data "template_file" "sa_definition" {
  template = file(var.service_account_file_name)
  vars = {
    project_id  = var.project_id
    environment = var.environment
  }
}