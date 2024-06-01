variable "kube_version" {
  type = string
}

variable "crio_version" {
  type = string
}

variable "hcloud_token" {
  sensitive   = true
  description = "HCloud Token"
  type        = string
}

variable "ssh_private_key_location" {
  type = string
}

variable "ssh_pub_key" {
  description = "Your SSH public key"
  type        = string
}

variable "control-plane" {
  description = "Control Plane List"
  type = map(object({
    name = string
    type = string
  }))
}

variable "worker" {
  description = "Worker List"
  type = map(object({
    name = string
    type = string
  }))
}