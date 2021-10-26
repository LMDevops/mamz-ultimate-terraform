resource "google_organization_iam_binding" "organizationAdmin" {
  org_id  = var.organization_id
  role    = "roles/resourcemanager.organizationAdmin"
  members = var.users
}

resource "google_organization_iam_binding" "projectCreator" {
  org_id  = var.organization_id
  role    = "roles/resourcemanager.projectCreator"
  members = var.users

  depends_on = [
    google_organization_iam_binding.organizationAdmin
  ]
}

resource "google_organization_iam_binding" "folderCreator" {
  org_id  = var.organization_id
  role    = "roles/resourcemanager.folderCreator"
  members = var.users

  depends_on = [
    google_organization_iam_binding.projectCreator
  ]
}

//role = "roles/owner"
