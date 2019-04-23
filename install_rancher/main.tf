provider "kubernetes" {
  config_path = "${var.kube_cluster_yaml}"
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }
}

provider "helm" {
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.13.0"

  kubernetes {
    config_path = "${var.kube_cluster_yaml}"
  }
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "stable/cert-manager"
  namespace = "kube-system"
  version   = "v0.5.2"
}

resource "helm_release" "rancher" {
  name       = "rancher"
  chart      = "rancher"
  version    = "${var.rancher_version}"
  repository = "https://releases.rancher.com/server-charts/latest/"
  namespace  = "cattle-system"

  set {
    name  = "hostname"
    value = "${var.le_hostname}"
  }

  set {
    name  = "ingress.tls.source"
    value = "letsEncrypt"
  }

  set {
    name  = "letsEncrypt.email"
    value = "${var.le_email}"
  }
}

# provider "rancher2" {
#   bootstrap = true
#   api_url   = "${var.le_hostname}"
# }
#
# resource "rancher2_bootstrap" "admin" {
#   password  = "fbYayodKoeEvXAxcokD8fpWn3UGDj6XmKwiwbvf1"
#   telemetry = true
# }

