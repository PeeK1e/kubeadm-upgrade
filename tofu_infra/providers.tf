terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    cilium = {
      source  = "littlejo/cilium"
      version = "0.2.5"
    }
  }
  backend "local" {
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "ssh" {
}

provider "cilium" {
  config_path = "${path.cwd}/local/kubeconfig"
}