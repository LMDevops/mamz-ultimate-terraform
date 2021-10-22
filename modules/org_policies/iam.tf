resource "google_organization_policy" "disable_automatic_iam_grants_for_default_service_accounts" {

  org_id     = var.organization_id
  constraint = "iam.automaticIamGrantsForDefaultServiceAccounts"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "disable_service_account_creation" {

  org_id     = var.organization_id
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_organization_policy" "disable_service_account_key_creation" {

  org_id     = var.organization_id
  constraint = "iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}
