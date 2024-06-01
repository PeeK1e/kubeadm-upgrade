resource "hcloud_load_balancer" "k8s" {
  name               = "k8s-lb"
  load_balancer_type = "lb11"
  location           = "nbg1"
}

resource "hcloud_load_balancer_network" "k8s" {
  load_balancer_id = hcloud_load_balancer.k8s.id
  network_id       = hcloud_network.k8s.id

  depends_on = [hcloud_network.k8s]
}

resource "hcloud_load_balancer_service" "api" {
  protocol         = "tcp"
  listen_port      = 6443
  load_balancer_id = hcloud_load_balancer.k8s.id
  destination_port = 6443
  depends_on       = [hcloud_load_balancer_network.k8s]
}

resource "hcloud_load_balancer_service" "http" {
  protocol         = "tcp"
  listen_port      = 80
  load_balancer_id = hcloud_load_balancer.k8s.id
  destination_port = 30080
  depends_on       = [hcloud_load_balancer_network.k8s]
}

resource "hcloud_load_balancer_service" "https" {
  protocol         = "tcp"
  listen_port      = 443
  load_balancer_id = hcloud_load_balancer.k8s.id
  destination_port = 30443
  depends_on       = [hcloud_load_balancer_network.k8s]
}

resource "hcloud_load_balancer_target" "cp" {
  type             = "label_selector"
  use_private_ip   = true
  label_selector   = "vm-type=cp"
  load_balancer_id = hcloud_load_balancer.k8s.id
  depends_on       = [hcloud_load_balancer_network.k8s]
}
