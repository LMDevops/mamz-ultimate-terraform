resource "google_folder" "sandbox" {
  display_name = "sandbox"
  parent       = "organizations/${var.organization_id}"
}

output "sandbox" {
  value = google_folder.sandbox.name
}
