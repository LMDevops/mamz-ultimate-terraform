resource "google_folder" "nonprod" {
  display_name = "nonprod"
  parent       = "organizations/${var.organization_id}"
}

output "nonprod" {
  value = google_folder.nonprod.name
}

resource "google_folder" "nonprod_Enterprise" {
  display_name = "Enterprise"
  parent       = google_folder.nonprod.name
}

output "nonprod-Enterprise" {
  value = google_folder.nonprod_Enterprise.name
}


resource "google_folder" "nonprod_Enterprise_Dedicated" {
  display_name = "Dedicated"
  parent       = google_folder.nonprod_Enterprise.name
}

output "nonprod-Enterprise-Dedicated" {
  value = google_folder.nonprod_Enterprise_Dedicated.name
}


resource "google_folder" "nonprod_Enterprise_Apps" {
  display_name = "Apps"
  parent       = google_folder.nonprod_Enterprise.name
}

output "nonprod-Enterprise-Apps" {
  value = google_folder.nonprod_Enterprise_Apps.name
}


resource "google_folder" "nonprod_Compliance" {
  display_name = "Compliance"
  parent       = google_folder.nonprod.name
}

output "nonprod-Compliance" {
  value = google_folder.nonprod_Compliance.name
}

resource "google_folder" "nonprod_Compliance_PCI" {
  display_name = "PCI"
  parent       = google_folder.nonprod_Compliance.name
}

output "nonprod-Compliance-PCI" {
  value = google_folder.nonprod_Compliance_PCI.name
}

resource "google_folder" "nonprod_Compliance_PHI" {
  display_name = "PHI"
  parent       = google_folder.nonprod_Compliance.name
}

output "nonprod-Compliance-PHI" {
  value = google_folder.nonprod_Compliance_PHI.name
}
