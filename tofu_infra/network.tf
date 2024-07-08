# cloud net
resource "hcloud_network" "k8s" {
  name     = "k8s_net"
  ip_range = "172.16.0.0/12"
}

# cloud subnet
resource "hcloud_network_subnet" "k8s" {
  network_id   = hcloud_network.k8s.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "172.16.1.0/24"
}

# cp network attachement
resource "hcloud_server_network" "cp" {
  for_each   = hcloud_server.control-planes
  server_id  = each.value.id
  network_id = hcloud_network.k8s.id
}

# worker network attachement
resource "hcloud_server_network" "worker" {
  for_each   = hcloud_server.worker
  server_id  = each.value.id
  network_id = hcloud_network.k8s.id
}

# firewall rules
resource "hcloud_firewall" "k8s_pub" {
  name = "k8s_pub"
  rule {
    protocol   = "tcp"
    direction  = "in"
    port       = 6443
    source_ips = ["0.0.0.0/0"]
  }
  rule {
    protocol   = "tcp"
    direction  = "in"
    port       = 22
    source_ips = ["0.0.0.0/0"]
  }
  rule {
    protocol   = "tcp"
    direction  = "in"
    port       = 30443
    source_ips = ["0.0.0.0/0"]
  }
  rule {
    protocol   = "tcp"
    direction  = "in"
    port       = 30080
    source_ips = ["0.0.0.0/0"]
  }
}

resource "hcloud_firewall" "k8s_intern" {
  name = "k8s_intern"
  rule {
    protocol  = "tcp"
    port      = "1-65535"
    direction = "in"
    source_ips = [
      hcloud_network.k8s.ip_range,
      "10.0.0.0/8"
    ]
  }
  rule {
    protocol  = "udp"
    port      = "1-65535"
    direction = "in"
    source_ips = [
      hcloud_network.k8s.ip_range,
      "10.0.0.0/8"
    ]
  }
}
