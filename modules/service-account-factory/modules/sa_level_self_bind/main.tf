resource "google_service_account_iam_member" "sa-asa-resource-bindings" {
  count              = length(var.service_account.sa_level_self_iam_bindings[var.counter].members)
  service_account_id = var.service_account_id
  role               = var.service_account.sa_level_self_iam_bindings[var.counter].role
  member             = var.service_account.sa_level_self_iam_bindings[var.counter].members[count.index]
}