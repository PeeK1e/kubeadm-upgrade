resource "hcloud_server" "worker" {
  for_each    = var.worker
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  location    = "nbg1"

  public_net {
    ipv6_enabled = true
  }

  ssh_keys = [
    hcloud_ssh_key.tofu-key.name
  ]

  labels = {
    vm-type = "worker"
  }

  # cloud init data
  user_data = local_file.cloud-init.content
}
