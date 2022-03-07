#Note that all org policies are set at the Org Level. 
#To re-target policies to the project or folder level, see here; https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_organization_policy


resource "google_organization_policy" "disable_nested_virtualization_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "compute.disableNestedVirtualization"
  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "serial_port_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "compute.disableSerialPortAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "vm_external_ip_access_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "compute.vmExternalIpAccess"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "skip_default_network_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "restrict_public_ip_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "sql.restrictPublicIp"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "allowed_policy_member_domains_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "constraints/iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      values = ["C01islvcf"]
    }
  }
}
# USE THIS BLOCK IF EXCLUSIONS ARE BEING SET ON THE ORGANIZATION LEVEL
resource "google_organization_policy" "disable_service_account_key_creation_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "iam.disableServiceAccountKeyCreation"
  boolean_policy {
    enforced = true
  }
}
/*
# USE THIS BLOCK IF EXCLUSIONS ARE BEING SET ON THE PROJECT LEVEL
resource "google_project_organization_policy" "allow_service_account_key" {
 for_each   = toset(var.allowed-key-projects)
  project    = each.value
  constraint = "iam.disableServiceAccountKeyCreation"
  boolean_policy {
    enforced = false
  }
}
*/

resource "google_organization_policy" "uniform_bucket_level_access_policy" {
  org_id     = data.google_organization.org.org_id
  constraint = "storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = true
  }
}