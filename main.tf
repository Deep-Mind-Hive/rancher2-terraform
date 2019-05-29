module "master_nodes" {
  source = "./do"
  node_name_prefix = "tprice-rke-master"
  node_count = 1
}

module "worker_nodes" {
  source = "./do"
  node_name_prefix = "tprice-rke-worker"
  node_count = 3
}

data "null_data_source" "ssh_keys" {
  inputs = {
    worker_ssh_key = module.worker_nodes.private_key
    master_ssh_key = module.master_nodes.private_key
  }
}

module "rke" {
  source = "./rke"
  master_nodes = module.master_nodes.addresses
  worker_nodes = module.worker_nodes.addresses
  user    = module.master_nodes.ssh_username
  ssh_key = data.null_data_source.ssh_keys.outputs
}

locals {
  address = module.worker_nodes.addresses[0]
}
module "install_rancher" {
  source = "./install_rancher"
  hostname = (var.hostname != null ? var.hostname : local.address)
  insecure = (var.insecure != null ? var.insecure : "true")
  email = var.email
  kube_cluster_yaml = module.rke.kube_cluster_yaml
  rancher_version = var.rancher_version
  # rancher2_admin_password = var.rancher2_admin_password
  tls_source = var.tls_source
}
