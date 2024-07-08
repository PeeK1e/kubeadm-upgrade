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
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
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
provider "helm" {
  kubernetes {
    config_path = "${path.cwd}/local/kubeconfig"
  }
}

provider "kubectl" {
  config_path = "${path.cwd}/local/kubeconfig"
  apply_retry_count = 4
}