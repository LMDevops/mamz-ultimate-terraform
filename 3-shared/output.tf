output "svpc_prj_id" {
  value = module.shared_vpc_host_project.project_id
}

output "log_mon_prj_id" {
  value = module.logging_monitoring_project.project_id
}

output "subnets" {
  value = module.svpc_network.subnetworks
}
