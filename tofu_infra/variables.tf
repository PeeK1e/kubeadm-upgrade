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