resource "tls_private_key" "ssh-key" {
  algorithm = "ED25519"
}

resource "local_file" "public_key" {
  filename = "${path.cwd}/local/tofu-ssh.pub"
  file_permission = "0600"
  content  = tls_private_key.ssh-key.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${path.cwd}/local/tofu-ssh"
  file_permission = "0600"
  content  = tls_private_key.ssh-key.private_key_openssh
}
