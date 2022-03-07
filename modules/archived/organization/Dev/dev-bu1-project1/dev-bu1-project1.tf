/******************************************
  Query data from GCP - Organization ID
*****************************************/

data "google_organization" "org" {
  domain = var.domain_name
}

/******************************************
  Create the project using the Google project factory module
*****************************************/

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = var.project_name
  random_project_id = true
  org_id            = data.google_organization.org.org_id
  folder_id         = var.parent_folder
  billing_account   = var.billing_account
}

/******************************************
  Create Service Accounts - IAM
*****************************************/
locals {
  service_accounts = fileset("${path.root}/dev-bu1-project1/dev-bu1-service-accounts", "*")
}

module "sa_creator_factory" {
  for_each                  = local.service_accounts
  source                    = "./../../../modules/service-account-factory"
  project_id                = module.project-factory.project_id
  environment               = "dev"
  service_account_file_name = "${path.root}/dev-bu1-project1/dev-bu1-service-accounts/${each.key}"
}

/******************************************
  Apply IAM bindings - IAM
*****************************************/
resource "google_project_iam_member" "monitoring_admin_roles" {
  for_each = toset(var.monitoring_admin_roles)
  project  = module.project-factory.project_id
  role     = each.value
  member   = "group:gcp-devops@sadasola.com"
}

/******************************************
  Create Firewall Rules
*****************************************/

/******************************************
  Create app specific resources
*****************************************/