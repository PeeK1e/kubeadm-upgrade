# Kubeadm Upgrade

⚠ **Kubernetes 1.30 is not yet supported, since there are some changes in the kubeadm upgrade steps** ⚠

You can upgrade your kubeadm, cri-o, Debian 11/12 based kubernetes cluster with this ansible script

<img src="./res/me_upgrading_the_cluster.png" alt="people praying to a server rack" width="200"/>

## Getting Started

### Dependencies

* ansible
* ansible-playbook
* python3

### Settings

Copy the `inventory.testing` file and fill in your nodes. **Make sure to use the host name, the nodes have in the cluster, since this script uses these to drain the nodes via kubectl**

In the `group_vars` check the global options. It's best to run the playbook once for your current version, to make sure that you're on the latest patch version.

### Usage

Run the playbook with `ansible-playbook -i inventory --private-key=~/.ssh/ssh-key upgrade_cluster.yaml`. Grab a cup of coffee and wait.

