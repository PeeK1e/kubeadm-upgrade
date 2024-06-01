resource "hcloud_server" "worker" {
  for_each    = var.worker
  name        = each.value.name
  image       = "debian-12"
  server_type = each.value.type
  public_net {
    ipv6_enabled = false
  }
  ssh_keys = [
    hcloud_ssh_key.tofu-key.name
  ]

  labels = {
    vm-type = "worker"
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
packages:
    - cri-o-runc
    - cri-o
runcmd:
  - apt install -y kubeadm=${var.kube_version}.* kubectl=${var.kube_version}.* kubelet=${var.kube_version}.*
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
  - sudo sysctl --system
  - sudo systemctl enable --now crio
  - sudo rm -rf "/etc/cni/net.d/*"
EOT
}
