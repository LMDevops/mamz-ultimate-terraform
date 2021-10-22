# module.core_automation_service_account.google_project_iam_member.project-roles["gc-sa-tf-pr-gcp-medx-auto-tf-01-2d0d=>roles/owner"] will be created
resource "google_storage_bucket" "bucket" {
    force_destroy               = false
    labels                      = var.labels
    location                    = "US"
    name                        = var.name
    project                     = var.project
    storage_class               = "STANDARD"
    uniform_bucket_level_access = true

    versioning {
        enabled = true
      }
  }

# # module.core_automation_bucket.google_storage_bucket_iam_member.members["roles/storage.objectAdmin serviceAccount:gc-sa-tf-pr@gcp-medx-auto-tf-01-0333.iam.gserviceaccount.com"] will be created
# resource "google_storage_bucket_iam_member" "members" {
#     bucket = google_storage_bucket.bucket.name
#     member = var.member
#     role   = "roles/storage.objectAdmin"
#   }
