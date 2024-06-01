# Testing Infrastructure

This `OpenTofu` script sets up Infrastructure to test the ansible upgrade script.
We use `cri-o`, `kubeadm` and `cilium` to setup the cluster.

## Setup
1. Get your API token (Read + Write) for Hetzner Cloud in the Hetzner Console:
    `https://console.hetzner.cloud/projects/<id>/security/tokens`
2. Paste it into the variables.tfvars

## Run
1. `tofu init`
2. `tofu apply -var-file=variables.tfvars`

If you encounter any issue with the cilium install, just run the script again and it should work.

## Output
You will receive an `inventory`,`kubeconfig` and `ssh-key` files in the `local/` directory which you can use to test the cluster.
You may have to copy the files to your `~/.ssh` directory in order to connect via ssh.
