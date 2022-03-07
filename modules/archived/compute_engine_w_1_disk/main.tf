/*
 * Copyright (c) 2019 Teradici Corporation
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

locals {

  # Windows computer names must be <= 15 characters
  # host_name                  = substr("${local.prefix}vm", 0, 15)
}

resource "google_compute_disk" "gce_disk_1" {
  project = var.project_id
  name    = "${var.gcp_host_name}-data-disk-1"
  type    = "pd-ssd"
  size    = var.gcp_data_disk_1_size
  zone    = var.gcp_zone
}

resource "google_compute_attached_disk" "gce_attach_disk_1" {
  project  = var.project_id
  disk     = google_compute_disk.gce_disk_1.name
  instance = google_compute_instance.gc_compute_engine.self_link
}

resource "google_compute_instance" "gc_compute_engine" {
  provider = google
  name     = var.gcp_host_name

  project      = var.project_id
  zone         = var.gcp_zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.disk_image
      type  = "pd-ssd"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    subnetwork = var.subnet
    network_ip = var.private_ip
    #    access_config {
    #    }
  }

  tags = var.network_tags

  # metadata = {
  #   sysprep-specialize-script-url = "gs://${var.bucket_name}/${google_storage_bucket_object.dc-sysprep-script.output_name}"
  # }

  service_account {
    email  = var.gcp_service_account == "" ? null : var.gcp_service_account
    scopes = ["cloud-platform"]
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}

# resource "null_resource" "upload-scripts" {
#   depends_on = [google_compute_instance.dc]
#   triggers = {
#     instance_id = google_compute_instance.dc.instance_id
#   }

#   connection {
#     type     = "winrm"
#     user     = "Administrator"
#     password = local.admin_password
#     # host     = google_compute_instance.dc.network_interface[0].access_config[0].nat_ip
#     host     = google_compute_instance.dc.network_interface[0].network_ip
#     port     = "5986"
#     https    = true
#     insecure = true
#   }

#   provisioner "file" {
#     content     = data.template_file.dc-provisioning-script.rendered
#     destination = local.provisioning_file
#   }

#   provisioner "file" {
#     content     = data.template_file.new-domain-admin-user-script.rendered
#     destination = local.new_domain_admin_user_file
#   }

#   provisioner "file" {
#     content     = data.template_file.new-domain-users-script.rendered
#     destination = local.new_domain_users_file
#   }
# }

# resource "null_resource" "upload-domain-users-list" {
#   count = local.new_domain_users

#   depends_on = [google_compute_instance.dc]
#   triggers = {
#     instance_id = google_compute_instance.dc.instance_id
#   }

#   connection {
#     type     = "winrm"
#     user     = "Administrator"
#     password = local.admin_password
#     host     = google_compute_instance.dc.network_interface[0].access_config[0].nat_ip
#     port     = "5986"
#     https    = true
#     insecure = true
#   }

#   provisioner "file" {
#     source      = var.domain_users_list
#     destination = local.domain_users_list_file
#   }
# }

# resource "null_resource" "run-provisioning-script" {
#   depends_on = [null_resource.upload-scripts]
#   triggers = {
#     instance_id = google_compute_instance.dc.instance_id
#   }

#   connection {
#     type     = "winrm"
#     user     = "Administrator"
#     password = local.admin_password
#     host     = google_compute_instance.dc.network_interface[0].access_config[0].nat_ip
#     port     = "5986"
#     https    = true
#     insecure = true
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "powershell -file ${local.provisioning_file}",
#       "del ${replace(local.provisioning_file, "/", "\\")}",
#     ]
#   }
# }

# resource "time_sleep" "wait-for-reboot" {
#   depends_on = [null_resource.run-provisioning-script]
#   triggers = {
#     instance_id = google_compute_instance.dc.instance_id
#   }
#   create_duration = "15s"
# }

# resource "null_resource" "new-domain-admin-user" {
#   depends_on = [
#     null_resource.upload-scripts,
#     time_sleep.wait-for-reboot,
#   ]
#   triggers = {
#     instance_id = google_compute_instance.dc.instance_id
#   }

#   connection {
#     type     = "winrm"
#     user     = "Administrator"
#     password = local.admin_password
#     host     = google_compute_instance.dc.network_interface[0].access_config[0].nat_ip
#     port     = "5986"
#     https    = true
#     insecure = true
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "powershell -file ${local.new_domain_admin_user_file}",
#       "del ${replace(local.new_domain_admin_user_file, "/", "\\")}",
#     ]
#   }
# }

# resource "null_resource" "new-domain-user" {
#   count = local.new_domain_users

#   # Waits for new-domain-admin-user because that script waits for ADWS to be up
#   depends_on = [
#     null_resource.upload-domain-users-list,
#     null_resource.new-domain-admin-user,
#   ]

#   triggers = {
#     instance_id = google_compute_instance.dc.instance_id
#   }

#   connection {
#     type     = "winrm"
#     user     = "Administrator"
#     password = local.admin_password
#     host     = google_compute_instance.dc.network_interface[0].access_config[0].nat_ip
#     port     = "5986"
#     https    = true
#     insecure = true
#   }

#   provisioner "remote-exec" {
#     # wait in case csv file is newly uploaded
#     inline = [
#       "powershell sleep 2",
#       "powershell -file ${local.new_domain_users_file}",
#       "del ${replace(local.new_domain_users_file, "/", "\\")}",
#       "del ${replace(local.domain_users_list_file, "/", "\\")}",
#     ]
#   }
# }
