resource "cilium" "cilium" {
  set = [
    "ipam.mode=kubernetes",
    "ipam.operator.replicas=1",
    "tunnel=vxlan",
  ]
  version   = "1.14.5"
  reuse     = true
  wait      = false
  data_path = "native"

  depends_on = [
    local_file.kubeconfig,
    ssh_resource.join_command,
    ssh_resource.certificate,
    ssh_resource.join-cp,
    ssh_resource.join-worker
  ]
}