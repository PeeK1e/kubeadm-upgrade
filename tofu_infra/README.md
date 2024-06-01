# Testing Infrastructure

This `OpenTofu` script sets up Infrastructure to test the ansible upgrade script.

## Setup
1. Get your API token for Hetzner Cloud in your console:
    `https://console.hetzner.cloud/projects/<id>/security/token`
2. Paste it into the variables.tfvars
3. fill out the ssh key fields

## Run
`tofu apply -var-file=variables.tfvars`

## Output
You will receive an `inventory` and `kubeconfig` file in the `local/` directory which you can use to test the cluster.
