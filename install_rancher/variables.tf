variable "hostname" {
  type = string
}

variable "email" {
  type = string
  default = null
}

variable "kube_cluster_yaml" {
  type = string
  default = ""
}

variable "tls_source" {
  type = string
  default = "letsEncrypt"
}

variable "rancher_version" {
  type = string
  default = "2.2.3"
}

# variable "rancher2_admin_password" {
#   type = string
# }

variable "insecure" {
  type = string
  default = null
}
