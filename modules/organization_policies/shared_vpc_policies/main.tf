resource "google_folder_organization_policy" "project_shared_vpc_restrict_subnetworks" {
  for_each   = toset(var.subnets)
  folder     = var.folder
  constraint = "compute.restrictSharedVpcSubnetworks"

  list_policy {
    deny {
      value = [each.value]
    }
  }
}
