/*
 * Copyright (c) 2019 Teradici Corporation
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

output "internal-ip" {
  value = google_compute_instance.gc_compute_engine.network_interface[0].network_ip
}

output "gce_self_link" {
  value = google_compute_instance.gc_compute_engine.self_link  
}

output "gce_instance_name" {
  value = google_compute_instance.gc_compute_engine.name
}

# output "public-ip" {
#   value = google_compute_instance.dc.network_interface[0].access_config[0].nat_ip
# }
