resource "google_project_iam_member" "admin_iam_roles" {
  for_each = toset(var.admin_roles)
  project  = var.project_id
  role     = each.key
  member   = "group:${var.group_name}"
}
