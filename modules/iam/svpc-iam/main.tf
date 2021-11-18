resource "google_project_iam_member" "network_users" {
  for_each = toset(var.groups)
  project  = var.network_project_id
  role     = "roles/compute.networkUser"
  member   = "group:${each.key}"
}
