module "bootstrap_permissions" {
  source = "../modules/bootstrap_permissions"
  organization_id = var.organization_id
  users = var.users
}

module "bootstrap_setup" {
  source = "../modules/bootstrap_setup"
  
  organization_id = var.organization_id
  billing_account = var.billing_account
  labels          = var.labels

  depends_on = [
    module.bootstrap_permissions
  ]
}
