/*
 * Copyright (c) 2019 Teradici Corporation
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

# variable "prefix" {
#   description = "Prefix to be applied to the name of the GCE"
# }

variable "gcp_service_account" {
  description = "Service Account in the GCP Project"
  type        = string
}

variable "gcp_host_name" {
  description = "Host name to be assigned to the VM"
  type        = string
}

variable "gcp_zone" {
  description = "Zone to deploy the Domain Controller"
  default     = "us-central1-b"
}

variable "subnet" {
  description = "Subnet to deploy the Domain Controller"
  type        = string
}

variable "private_ip" {
  description = "Static internal IP address for the Domain Controller"
  type        = string
}

variable "network_tags" {
  description = "Tags to be applied to the Domain Controller"
  type        = list(string)
}

variable "machine_type" {
  description = "Machine type for the Domain Controller"
  default     = "n1-standard-4"
}

variable "disk_size_gb" {
  description = "Disk size (GB) of the Domain Controller"
  default     = "50"
}

variable "disk_image" {
  description = "Disk image for the Domain Controller"
  default     = "projects/windows-cloud/global/images/family/windows-2019"
}

variable "project_id" {

}