locals {
  sa = jsondecode(data.template_file.sa_definition.rendered)
}

resource "google_service_account" "service_account" {
  account_id   = local.sa.name
  project      = local.sa.owner_project_id
  display_name = local.sa.display_name
  description  = local.sa.description
}
/* module "sa_project_level_bind" {
  count           = length(local.sa.project_level_iam_bindings)
  counter         = count.index
  email           = google_service_account.service_account.email
  source          = "./modules/sa_project_level_bind"
  service_account = local.sa
}
module "sa_level_self_bind" {
  count              = length(local.sa.sa_level_self_iam_bindings)
  counter            = count.index
  service_account_id = google_service_account.service_account.name
  source             = "./modules/sa_level_self_bind"
  service_account    = local.sa
} */