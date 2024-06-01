# Testing Infrastructure

This `OpenTofu` script sets up Infrastructure to test the ansible upgrade script.

## Setup
1. Get your API token (Read + Write) for Hetzner Cloud in the Hetzner Console:
    `https://console.hetzner.cloud/projects/<id>/security/tokens`
2. Paste it into the variables.tfvars

## Run
`tofu init`
`tofu apply -var-file=variables.tfvars`

## Output
You will receive an `inventory` and `kubeconfig` file in the `local/` directory which you can use to test the cluster.

⚠ The script will create a file in your `~/.ssh` directory called `~/.ssh/tofu-ssh` make sure that is not overwritten when running the script ⚠
