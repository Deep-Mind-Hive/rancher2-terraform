output "master_addresses" {
  value = module.master_nodes.addresses
}

output "worker_addresses" {
  value = module.worker_nodes.addresses
}
