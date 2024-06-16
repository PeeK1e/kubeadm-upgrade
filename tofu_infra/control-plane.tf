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
  user_data = <<-EOT
#cloud-config
# mirror setup
apt:
  sources:
    kubernetes.list:
      source: "deb [signed-by=$KEY_FILE] https://pkgs.k8s.io/core:/stable:/v${var.kube_version}/deb/ /"
      keyid: DE15B14486CD377B9E876E1A234654DA9A296436
      filename: kubernetes.list
    crio.list:
      source: "deb [signed-by=$KEY_FILE] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/${var.crio_version}/Debian_12/ /"
      keyid: 2472D6D0D2F66AF87ABA8DA34D64390375060AA4
      filename: crio.list
    kubic.list:
      source: "deb [signed-by=$KEY_FILE] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_12/ /"
      keyid: 2472D6D0D2F66AF87ABA8DA34D64390375060AA4
      filename: kubic.list
# install packages
package_update: true
runcmd:
  - |
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF
  - |
    cat <<EOF | tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
    EOF
  - sudo modprobe overlay 
  - sudo modprobe br_netfilter 
  - sysctl -p
  - sudo rm -rf "/etc/cni/net.d/*"
EOT
}
