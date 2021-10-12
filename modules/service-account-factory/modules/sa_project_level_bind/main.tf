resource "google_project_iam_member" "project" {
  count   = length(var.service_account.project_level_iam_bindings[var.counter].project_level_roles)
  project = var.service_account.project_level_iam_bindings[var.counter].project_id
  role    = var.service_account.project_level_iam_bindings[var.counter].project_level_roles[count.index]
  member  = "serviceAccount:${var.email}"
}
