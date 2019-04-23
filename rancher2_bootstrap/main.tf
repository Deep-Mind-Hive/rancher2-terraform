provider "rancher2" {
  bootstrap = true
  api_url   = "https://${var.le_hostname}"
}

resource "rancher2_bootstrap" "admin" {
  password  = "${var.rancher2_admin_password}"
  telemetry = true

  # token_update = true
}

output "token" {
  value = "${rancher2_bootstrap.admin.token}"
}
