resource "hcloud_server" "control-planes" {
  for_each    = var.control-plane
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  public_net {
    ipv6_enabled = true
  }
  ssh_keys = [
    hcloud_ssh_key.tofu-key.name
  ]

  # connection type, ssh
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
  }

  firewall_ids = [
    hcloud_firewall.k8s_intern.id,
    hcloud_firewall.k8s_pub.id
  ]

  labels = {
    vm-type = "cp"
  }

  # cloud init data
  user_data = local_file.cloud-init.content
}
