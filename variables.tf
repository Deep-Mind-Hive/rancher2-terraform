variable "hostname" {
  type = string
  default = "example.com"
}
variable "email" {
  type = string
  default = null
}

variable "insecure" {
  type = string
  default = null
}

variable "rancher_version" {
  type = string
  default = "2.2.2"
}

# variable "rancher2_admin_password" {
#   type = string
# }

variable "tls_source" {
  type = string
  default = null
}
