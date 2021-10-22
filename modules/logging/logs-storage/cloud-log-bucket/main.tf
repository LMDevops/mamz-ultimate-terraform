/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  location = var.location != "" ? var.location : "global"
  destination_uri     = "logging.googleapis.com/projects/${var.project_id}/locations/${local.location}/buckets/${var.bucket_id}"
}

#----------------#
# API activation #
#----------------#
# resource "google_project_service" "enable_destination_api" {
#   project            = var.project_id
#   service            = "storage-component.googleapis.com"
#   disable_on_destroy = false
# }

#----------------#
# Project cloud logging bucket #
#----------------#
resource "google_logging_project_bucket_config" "cloud_log_bucket" {
    project    = var.project_id
    location  = local.location
    retention_days = var.retention_days > 0 ? var.retention_days : 30
    bucket_id = var.bucket_id
}


#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_binding" "storage_sink_member" {
  project = var.project_id
  #bucket = local.storage_bucket_name
  role   = "roles/logging.bucketWriter"
  members = [ var.log_sink_writer_identity ]
}
