resource "hcloud_ssh_key" "tofu-key" {
  name       = "tofu-key"
  public_key = var.ssh_pub_key
}

resource "ssh_resource" "bootstrap_first_cp" {
  host = hcloud_server.control-planes[keys(var.control-plane)[0]].ipv4_address
  # host = hcloud_server_network.cp[keys(var.control-plane)[0]].ip
  user = "root"
  when = "create"

  agent       = false
  private_key = var.ssh_private_key_location

  commands = [
    <<EOF
        kubeadm init \
            --apiserver-advertise-address ${hcloud_server_network.cp[keys(var.control-plane)[0]].ip} \
            --control-plane-endpoint ${hcloud_load_balancer.k8s.ipv4} \
            --cri-socket="unix:///var/run/crio/crio.sock" \
            --pod-network-cidr 10.0.0.0/8 \
            --service-cidr 10.96.0.0/16
        EOF
  ]
  depends_on = [
    hcloud_load_balancer.k8s,
    hcloud_server.control-planes,
    hcloud_load_balancer_target.cp,
    hcloud_load_balancer_network.k8s
  ]
}

resource "ssh_resource" "get_admin_conf" {
  host = hcloud_server.control-planes[keys(var.control-plane)[0]].ipv4_address
  # host = hcloud_server_network.cp[keys(var.control-plane)[0]].ip
  user = "root"
  when = "create"

  agent       = false
  private_key = var.ssh_private_key_location

  commands = [
    <<EOF
        cat /etc/kubernetes/admin.conf
        EOF
  ]
  depends_on = [
    hcloud_load_balancer.k8s,
    hcloud_server.control-planes,
    hcloud_load_balancer_target.cp,
    hcloud_load_balancer_network.k8s,
    ssh_resource.bootstrap_first_cp
  ]
}

resource "local_file" "kubeconfig" {
  filename = "local/kubeconfig"
  content  = ssh_resource.get_admin_conf.result
}

resource "ssh_resource" "certificate" {
  host = hcloud_server.control-planes[keys(var.control-plane)[0]].ipv4_address
  # host = hcloud_server_network.cp[keys(var.control-plane)[0]].ip
  user = "root"
  when = "create"

  agent       = false
  private_key = var.ssh_private_key_location

  commands = [
    <<EOT
        kubeadm init phase upload-certs --upload-certs 2>/dev/null | grep -E -v "\[[a-z]*\-[a-z]*\]"
        EOT
  ]
  depends_on = [
    ssh_resource.bootstrap_first_cp
  ]
}

resource "ssh_resource" "join_command" {
  host = hcloud_server.control-planes[keys(var.control-plane)[0]].ipv4_address
  # host = hcloud_server_network.cp[keys(var.control-plane)[0]].ip
  user = "root"
  when = "create"

  agent       = false
  private_key = var.ssh_private_key_location

  commands = [
    <<EOT
        kubeadm token create --print-join-command
        EOT
  ]
  depends_on = [
    ssh_resource.bootstrap_first_cp
  ]
}

resource "ssh_resource" "join-cp" {
  for_each = {
    for key in keys(var.control-plane) :
    key => key if key != keys(var.control-plane)[0]
  }

  host = hcloud_server.control-planes[each.key].ipv4_address
  # host = hcloud_server_network.cp[keys(var.control-plane)[0]].ip
  user = "root"
  when = "create"

  agent       = false
  private_key = var.ssh_private_key_location

  commands = [
    <<EOT
${trim(ssh_resource.join_command.result, "\n")} \
    --control-plane \
    --certificate-key ${trim(ssh_resource.certificate.result, "\n")} \
    --apiserver-advertise-address ${hcloud_server_network.cp[each.key].ip}
EOT
  ]
  depends_on = [
    ssh_resource.join_command,
    ssh_resource.certificate
  ]
}

resource "ssh_resource" "join-worker" {
  for_each = var.worker

  host = hcloud_server.worker[each.key].ipv4_address
  user = "root"
  when = "create"

  agent       = false
  private_key = var.ssh_private_key_location

  commands = [
    <<EOT
        ${trim(ssh_resource.join_command.result, "\n")} \
            --apiserver-advertise-address ${hcloud_server_network.worker[each.key].ip}
        EOT
  ]
  depends_on = [
    ssh_resource.join_command,
    ssh_resource.certificate,
    ssh_resource.join-cp
  ]
}
