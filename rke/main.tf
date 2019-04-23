resource rke_cluster "cluster" {
  depends_on = ["var.master_nodes", "var.worker_nodes"]
  dynamic nodes {
    for_each = var.master_nodes
    content {
      address = nodes.value
      user    = "${var.user}"
      ssh_key = "${var.ssh_key["master_ssh_key"]}"
      role    = ["controlplane", "etcd"]
    }
  }
  dynamic nodes {
    for_each = var.worker_nodes
    content {
      address = nodes.value
      user    = "${var.user}"
      ssh_key = "${var.ssh_key["worker_ssh_key"]}"
      role    = ["worker"]
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "./kube_config_cluster.yml"
  content  = "${rke_cluster.cluster.kube_config_yaml}"
}
