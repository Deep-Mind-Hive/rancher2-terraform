variable "region" {
  default = "sfo2"
}

variable "droplet_size" {
  default = "s-2vcpu-4gb"
}

variable "node_name_prefix" {
  default = "rke-node"
}

variable "node_count" {
  default = 4
}
