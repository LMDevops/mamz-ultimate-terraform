resource "google_organization_policy" "disable_guest_attributes_of_compute_engine_metadata" {

  org_id     = var.organization_id
  constraint = "compute.disableGuestAttributesAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "disable_vm_nested_virtualization" {

  org_id     = var.organization_id
  constraint = "compute.disableNestedVirtualization"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "disable_vm_serial_port_access" {

  org_id     = var.organization_id
  constraint = "compute.disableSerialPortAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "restrict_shared_vpc_project_lien_removal" {

  org_id     = var.organization_id
  constraint = "compute.restrictXpnProjectLienRemoval"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "skip_default_network_creation" {

  org_id     = var.organization_id
  constraint = "compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "define_allowed_external_ips_for_vm_instances" {

  org_id     = var.organization_id
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    allow {
      all = true
    }
  }
}
