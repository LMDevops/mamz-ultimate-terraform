resource "google_folder" "vendor" {
  display_name = "vendor"
  parent       = "organizations/${var.organization_id}"
}

output "vendor" {
  value = google_folder.vendor.name
}

resource "google_folder" "vendor_citrix" {
  display_name = "citrix"
  parent       =google_folder.vendor.name
}

output "vendor_citrix" {
  value = google_folder.vendor_citrix.name
}

resource "google_folder" "vendor_citrix_prod" {
  display_name = "prod"
  parent       =google_folder.vendor_citrix.name
}

output "vendor_citrix_prod" {
  value = google_folder.vendor_citrix_prod.name
}

resource "google_folder" "vendor_citrix_nonprod" {
  display_name = "nonprod"
  parent       =google_folder.vendor_citrix.name
}

output "vendor_citrix_nonprod" {
  value = google_folder.vendor_citrix_nonprod.name
}
