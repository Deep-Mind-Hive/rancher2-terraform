provider "digitalocean" {}

resource tls_private_key "node-key" {
  algorithm = "RSA"
}

resource "random_string" "key-suffix" {
  length = 10
  special = false
}

resource "local_file" "private-key" {
  filename = "./private-key-${random_string.key-suffix.result}"
  content  = "${tls_private_key.node-key.private_key_pem}"
}


resource "digitalocean_ssh_key" "key" {
  name       = "${var.node_name_prefix}-key-${random_string.key-suffix.result}"
  public_key = "${tls_private_key.node-key.public_key_openssh}"
}

resource "digitalocean_droplet" "rke-node" {
  image    = "ubuntu-18-04-x64"
  name     = "${var.node_name_prefix}-${count.index+1}"
  region   = "${var.region}"
  size     = "${var.droplet_size}"
  ssh_keys = ["${digitalocean_ssh_key.key.id}"]
  count    = var.node_count

  provisioner "remote-exec" {
    connection {
      user        = "root"
      host        = "${self.ipv4_address}"
      private_key = "${tls_private_key.node-key.private_key_pem}"
    }

    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "apt-get update",
      "apt-get install -y docker-ce docker-ce-cli containerd.io"
    ]
  }
}

resource "null_resource" "complete" {
  triggers = {
    instances = "${join(",", digitalocean_droplet.rke-node.*.ipv4_address)}"
  }
}
