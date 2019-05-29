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
    value = "${var.hostname}"
  }

  set {
    name  = "ingress.tls.source"
    value = "${var.tls_source}"
  }

  set {
    name  = "letsEncrypt.email"
    value = "${var.email}"
  }
}

provider "rancher2" {
  bootstrap = true
  api_url   = "https://${var.hostname}"
  insecure = var.insecure
}

resource "rancher2_bootstrap" "admin" {
  password  = "${var.rancher2_admin_password}"
  telemetry = true

  # token_update = true
}
