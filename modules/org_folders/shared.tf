resource "google_folder" "shared" {
  display_name = "shared"
  parent       = "organizations/${var.organization_id}"
}

output "shared" {
  value = google_folder.shared.name
}


resource "google_folder" "shared_security" {
  display_name = "security"
  parent       = google_folder.shared.name
}

output "shared-security" {
  value = google_folder.shared_security.name
}

resource "google_folder" "shared_network" {
  display_name = "network"
  parent       = google_folder.shared.name
}

output "shared-network" {
  value = google_folder.shared_network.name
}

resource "google_folder" "shared_network_prod" {
  display_name = "prod"
  parent       = google_folder.shared_network.name
}

output "shared-network-prod" {
  value = google_folder.shared_network_prod.name
}

resource "google_folder" "shared_network_nonprod" {
  display_name = "nonprod"
  parent       = google_folder.shared_network.name
}

output "shared-network-nonprod" {
  value = google_folder.shared_network_nonprod.name
}

resource "google_folder" "shared_common_services" {
  display_name = "common-services"
  parent       = google_folder.shared.name
}

output "shared-common-services" {
  value = google_folder.shared_common_services.name
}

resource "google_folder" "shared_common_services_prod" {
  display_name = "prod"
  parent       = google_folder.shared_common_services.name
}

output "shared-common-services-prod" {
  value = google_folder.shared_common_services_prod.name
}

resource "google_folder" "shared_common_services_nonprod" {
  display_name = "nonprod"
  parent       = google_folder.shared_common_services.name
}

output "shared-common-services-nonprod" {
  value = google_folder.shared_common_services_nonprod.name
}

resource "google_folder" "shared_observability" {
  display_name = "observability"
  parent       = google_folder.shared.name
}

output "shared-observability" {
  value = google_folder.shared_observability.name
}

resource "google_folder" "shared_observability_prod" {
  display_name = "prod"
  parent       = google_folder.shared_observability.name
}

output "shared-observability-prod" {
  value = google_folder.shared_observability_prod.name
}

resource "google_folder" "shared_observability_nonprod" {
  display_name = "nonprod"
  parent       = google_folder.shared_observability.name
}

output "shared-observability-nonprod" {
  value = google_folder.shared_observability_nonprod.name
}
