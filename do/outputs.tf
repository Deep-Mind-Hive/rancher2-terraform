output "ssh_username" {
  value = "root"
}

# output "addresses" {
#   value = ["${digitalocean_droplet.rke-node.*.ipv4_address}"]
# }

output "addresses" {
  value = {
    for instance in digitalocean_droplet.rke-node:
    instance.name => instance.ipv4_address
  }
}

output "private_key" {
  value = "${tls_private_key.node-key.private_key_pem}"
}
