resource "google_project_iam_member" "pr-svc-wdc-01-nonprod-iam" {
    for_each = toset(var.role_names)
    project = var.project_id 
    role    = each.key
    member  = "group:${var.group_name}"
}