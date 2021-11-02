resource "google_project_iam_member" "admin_iam_roles" {
  for_each = toset(var.admin_roles)
  project  = var.project_id
  role     = each.key
  member   = "group:${var.admin_group_name}"
}

resource "google_project_iam_member" "developer_iam_roles" {
  for_each = toset(var.developer_roles)
  project  = var.project_id
  role     = each.key
  member   = "group:${var.developer_group_name}"
}

resource "google_project_iam_member" "devops_iam_roles" {
  for_each = toset(var.devops_roles)
  project  = var.project_id
  role     = each.key
  member   = "group:${var.devops_group_name}"
}
