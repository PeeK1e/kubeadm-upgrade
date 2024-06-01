hcloud_token             = "{hcloud api key}"

# the crio version wanted
# currently still using the suse mirrors so only <= 1.28 is supported
crio_version = "1.28"

# kubernetes version
kube_version = "1.29"

worker = {
  "w-1" = {
    name = "w-1"
    type = "cax11"
  },
  # "w-2" = {
  #   name = "w-2"
  #   type = "cax11"
  # },
  # "w-3" = {
  #   name = "w-3"
  #   type = "cax11"
  # }
}

control-plane = {
  "cp1" = {
    name = "cp-1"
    type = "cax11"
  },
  # "cp2" = {
  #   name = "cp-2"
  #   type = "cax11"
  # },
  # "cp3" = {
  #   name = "cp-3"
  #   type = "cax11"
  # }
}