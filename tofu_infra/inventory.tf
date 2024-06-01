resource "local_file" "inventory" {
  filename = "local/inventory"
  content  = <<-EOF
[control-plane]
%{for machine in hcloud_server.control-planes~}
${machine.name} ansible_host=${machine.ipv4_address} ansible_user=root ansible_port=22 ansible_ssh_private_key_file=${local_file.private_key.filename}
%{endfor~}

[nodes]
%{for machine in hcloud_server.worker~}
${machine.name} ansible_host=${machine.ipv4_address} ansible_user=root ansible_port=22 ansible_ssh_private_key_file=${local_file.private_key.filename}
%{endfor~}
EOF
}
