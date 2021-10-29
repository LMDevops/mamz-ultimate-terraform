## Useful Links
// Terraform - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
// GCLOUD - https://cloud.google.com/sdk/gcloud/reference/compute/networks/subnets/create
## Known Issues
// https://github.com/hashicorp/terraform-provider-google/issues/2570 - Error updating secondary IP ranges in Google_compute_subnetwork 
////  Cannot add and remove secondary IP ranges in the same request.

locals {
  subnetwork_defaults = {
    purpose          = "PRIVATE"
    secondary_ranges = []
    role             = "ACTIVE"
    log_config = {
      enabled              = false
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 50
      metadata             = "INCLUDE_ALL_METADATA"
      metadata_fields      = []
    }
  }

  subnetworks = merge(flatten([
    for network in var.network_configs : {
      for primary_subnetwork in network.subnetworks : "${network.name}-${lower(primary_subnetwork.region)}-${try(primary_subnetwork.name, primary_subnetwork.ip_cidr_range)}" => {
        name    = try(primary_subnetwork._name, "${network.name}-${module.gcp_utils.region_short_name_map[lower(primary_subnetwork.region)]}-primary-${replace(primary_subnetwork.ip_cidr_range, "//|\\./", "-")}")
        network = "${var.prefix}-${var.environment}-vpc-${network.name}"

        purpose = try(primary_subnetwork.purpose, "PRIVATE")

        // First Check
        //// Is primary_subnetwork.purpose either OneOf["INTERNAL_HTTPS_LOAD_BALANCER"], if so primary_subnetwork.role is set to value from JSON
        // else
        //// primary_subnetwork.role is set to null
        role = (contains(["INTERNAL_HTTPS_LOAD_BALANCER"], try(primary_subnetwork.purpose, "PRIVATE"))) ? try(primary_subnetwork.role, "ACTIVE") : null

        // First Check
        //// Is primary_subnetwork.purpose either OneOf["INTERNAL_HTTPS_LOAD_BALANCER","PRIVATE_SERVICE_CONNECT"], if so primary_subnetwork.private_ip_google_access == false
        // Second Check
        //// Is primary_subnetwork.private_ip_google_access set to DISABLED, if so primary_subnetwork.private_ip_google_access == false
        // else
        //// primary_subnetwork.private_ip_google_access == true        
        private_ip_google_access = (contains(["INTERNAL_HTTPS_LOAD_BALANCER", "PRIVATE_SERVICE_CONNECT"], try(primary_subnetwork.purpose, "PRIVATE"))) ? false : (contains(["DISABLED"], try(primary_subnetwork.private_ip_google_access, "ENABLED"))) ? false : true

        region        = lower(primary_subnetwork.region)
        ip_cidr_range = primary_subnetwork.ip_cidr_range

        secondary_subnetworks = try(
          [for secondary_subnetwork in primary_subnetwork.secondary_subnetworks : {
            range_name    = "${network.name}-${module.gcp_utils.region_short_name_map[lower(primary_subnetwork.region)]}-secondary-${replace(secondary_subnetwork.ip_cidr_range, "//|\\./", "-")}"
            ip_cidr_range = secondary_subnetwork.ip_cidr_range
        }], [])

        log_config = {
          enabled              = (try(primary_subnetwork.log_config.enabled, false) && try(primary_subnetwork.purpose, "PRIVATE") == "PRIVATE") ? true : false
          aggregation_interval = try(primary_subnetwork.log_config.aggregation_interval, "INTERVAL_5_SEC")
          flow_sampling        = try(primary_subnetwork.log_config.flow_sampling, 50) / 100
          metadata             = try(primary_subnetwork.log_config.metadata, local.subnetwork_defaults.log_config.metadata)
          metadata_fields      = (try(primary_subnetwork.log_config.metadata, local.subnetwork_defaults.log_config.metadata) == "CUSTOM_METADATA") ? try(primary_subnetwork.log_config.metadata_fields, local.subnetwork_defaults.log_config.metadata_fields) : []
        }
      }
    } if can(network.subnetworks)
  ])...)
}

// Creates all subnetwork types except those with role BACKUP
resource "google_compute_subnetwork" "subnetworks" {
  provider = google-beta

  project  = var.project_id
  for_each = { for key, value in local.subnetworks : key => value if value.role != "BACKUP" }

  name          = each.value.name
  region        = each.value.region
  network       = each.value.network
  ip_cidr_range = each.value.ip_cidr_range

  private_ip_google_access = each.value.private_ip_google_access

  purpose = each.value.purpose
  role    = each.value.role

  secondary_ip_range = each.value.secondary_subnetworks

  dynamic "log_config" {
    for_each = each.value.log_config.enabled ? [1] : []
    content {
      aggregation_interval = each.value.log_config.aggregation_interval
      flow_sampling        = each.value.log_config.flow_sampling
      metadata             = each.value.log_config.metadata
      metadata_fields      = each.value.log_config.metadata_fields
    }
  }

  depends_on = [
    google_compute_network.networks
  ]
}

# Backup Networks Need to be created After the primary network is setup
resource "google_compute_subnetwork" "subnetworks_backup" {
  provider = google-beta

  project  = var.project_id
  for_each = { for key, value in local.subnetworks : key => value if value.role == "BACKUP" }

  name          = each.value.name
  region        = each.value.region
  network       = each.value.network
  ip_cidr_range = each.value.ip_cidr_range

  purpose = each.value.purpose
  role    = each.value.role

  depends_on = [
    google_compute_subnetwork.subnetworks
  ]
}