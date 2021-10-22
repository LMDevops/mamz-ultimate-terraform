variable "project_id" {
  description = "The ID of the project in which the cloud logging bucket will be created."
  type        = string
}

variable "location" {
  description = "The location of the cloud logging bucket."
  type        = string
  default     = "global"
}

variable "retention_days" {
  description = "Number of days Logs will be retained by default, after which they will automatically be deleted."
  type        = number
  default     = null
}

variable "bucket_id" {
  description = "Custom bucket id assigned to the cloud logging bucket."
  type        = string
  default     = null
}

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}