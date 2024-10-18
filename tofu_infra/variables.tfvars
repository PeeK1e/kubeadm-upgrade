hcloud_token = "{hcloud api key}"

# the crio version wanted
# bumped to >1.28, starting with 1.28 there is a repo change. (https://github.com/cri-o/packaging/blob/d12f75b1322d9f8ef90559f51ea55fc09943d3aa/README.md#usage)
crio_version = "1.30"

# kubernetes version
kube_version = "1.30"

worker = {
  "w-1" = {
    name = "w-1"
    type = "cax11"
  },
  "w-2" = {
    name = "w-2"
    type = "cax11"
  },
  "w-3" = {
    name = "w-3"
    type = "cax11"
  }
}

control-plane = {
  "cp4" = {
    name = "cp-1"
    type = "cax11"
  },
  "cp2" = {
    name = "cp-2"
    type = "cax11"
  },
  "cp3" = {
    name = "cp-3"
    type = "cax11"
  }
}