variable "region" {
  type = string
  default = "sfo2"
}

variable "droplet_size" {
  type = string
  default = "s-2vcpu-4gb"
}

variable "node_name_prefix" {
  type = string
  default = "rke-node"
}

variable "node_count" {
  type = number
  default = 4
}
