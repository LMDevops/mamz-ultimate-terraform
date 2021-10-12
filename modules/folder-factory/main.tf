resource "google_folder" "gemp_dev" {
  display_name = var.folder_name
  parent       = "organizations/${data.google_organization.org.org_id}"
}