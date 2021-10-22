resource "google_folder" "prod" {
  display_name = "prod"
  parent       = "organizations/${var.organization_id}"
}

output "prod" {
  value = google_folder.prod.name
}

resource "google_folder" "prod_Enterprise" {
  display_name = "Enterprise"
  parent       = google_folder.prod.name
}

output "prod-Enterprise" {
  value = google_folder.prod_Enterprise.name
}

resource "google_folder" "prod_Enterprise_Dedicated" {
  display_name = "Dedicated"
  parent       = google_folder.prod_Enterprise.name
}

output "prod-Enterprise-Dedicated" {
  value = google_folder.prod_Enterprise_Dedicated.name
}

resource "google_folder" "prod_Enterprise_Apps" {
  display_name = "Apps"
  parent       = google_folder.prod_Enterprise.name
}

output "prod-Enterprise-Apps" {
  value = google_folder.prod_Enterprise_Apps.name
}

resource "google_folder" "prod_Compliance" {
  display_name = "Compliance"
  parent       = google_folder.prod.name
}

output "prod-Compliance" {
  value = google_folder.prod_Compliance.name
}

resource "google_folder" "prod_Compliance_PCI" {
  display_name = "PCI"
  parent       = google_folder.prod_Compliance.name
}

output "prod-Compliance-PCI" {
  value = google_folder.prod_Compliance.name
}

resource "google_folder" "prod_Compliance_PHI" {
  display_name = "PHI"
  parent       = google_folder.prod_Compliance.name
}

output "prod-Compliance-PHI" {
  value = google_folder.prod_Compliance_PHI.name
}
