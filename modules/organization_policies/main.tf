resource "google_organization_policy" "enforce_uniform_bucket-level_access" {

  org_id     = var.organization_id
  constraint = "storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = true
  }
}


#
# resource "google_organization_policy" "disable_code_download" {
#   org_id     = var.organization_id
#   constraint = "appengine.disableCodeDownload"
#
#   boolean_policy {
#     enforced = true
#   }
# }
#
# resource "google_organization_policy" "allowed_binary_authorization_policies_cloud_run" {
#   org_id     = var.organization_id
#   constraint = "run.allowedBinaryAuthorizationPolicies"
#
#   boolean_policy {
#     enforced = true
#   }
# }
#
# resource "google_organization_policy" "restrict_allowed_google_cloud_apis_and_services" {
#   org_id     = var.organization_id
#   constraint = "serviceuser.services"
#
#   boolean_policy {
#     enforced = true
#   }
# }
#
#
