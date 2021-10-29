resource "google_folder" "folders" {
  for_each = toset(local.folders)

  display_name = each.value
  parent       = "organizations/${data.terraform_remote_state.bootstrap.outputs.organization_id}"
}

module "organization_policies" {
  source = "../modules/organization_policies"

  organization_id = data.terraform_remote_state.bootstrap.outputs.organization_id
}

module "org_level_iam_group_bindings" {
  source = "../modules/iam/org-iam"
  domain = var.domain
  org_id = var.organization_id
}
