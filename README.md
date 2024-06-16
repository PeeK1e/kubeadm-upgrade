# ✨ Kubeadm Upgrade ✨

> **⚠️ Always test your upgrades on a test cluster first! ⚠️**

---

Upgrade your kubeadm, cri-o, Debian 11/12 based Kubernetes cluster with this Ansible playbook.

I tested it with version 1.28 through 1.30.
It should work with versions less than 1.28, depending on the mirror availability and packages on the mirrors.

## 🚀 Getting Started

### 📋 Dependencies

- `ansible`
- `ansible-playbook`
- `python3`

### ⚙️ Settings
> **⚠️ Use the exact host names as in your cluster since the script uses these to drain the nodes via kubectl ⚠️**

1. Copy `inventory.testing` and fill in your nodes.
2. In `group_vars`, check the global options. Run the playbook once for **your current version** to ensure you're on the latest patch version.

### ▶️ Usage

Run the playbook with:

```bash
ansible-playbook -i inventory --private-key=~/.ssh/ssh-key upgrade_cluster.yaml
```

There will be a prompt, where you're asked to confirm the plan. When you're satisfied with the planned output, press `ctrl+c` and `c` again to continue or `a` to abort.

All that's left is to grab a cup of coffee, wait, and pray.

<img src="./res/me_upgrading_the_cluster.png" alt="multiple people praying to a server rack" width="200"/>