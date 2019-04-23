output "kube_cluster_yaml" {
  value = "${local_file.kube_cluster_yaml.filename}"
}
