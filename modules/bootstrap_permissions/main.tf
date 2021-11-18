resource "google_organization_iam_member" "organizationAdmin" {
  for_each = toset(var.users)
  org_id   = var.organization_id
  role     = "roles/resourcemanager.organizationAdmin"
  member   = each.value
}

resource "google_organization_iam_member" "projectCreator" {
  for_each = toset(var.users)
  org_id   = var.organization_id
  role     = "roles/resourcemanager.projectCreator"
  member   = each.value

  depends_on = [
    google_organization_iam_member.organizationAdmin
  ]
}

resource "google_organization_iam_member" "owner" {
  for_each = toset(var.users)
  org_id   = var.organization_id
  role     = "roles/owner"
  member   = each.value

  depends_on = [
    google_organization_iam_member.organizationAdmin
  ]
}

resource "google_organization_iam_member" "folderAdmin" {
  for_each = toset(var.users)
  org_id   = var.organization_id
  role     = "roles/resourcemanager.folderAdmin"
  member   = each.value
}

# resource "google_organization_iam_binding" "folderAdmin" {
#   org_id  = var.organization_id
#   role    = "roles/resourcemanager.folderAdmin"
#   members = var.users

#   depends_on = [
#     google_organization_iam_member.projectCreator
#   ]
# }


