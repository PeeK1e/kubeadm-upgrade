resource "tls_private_key" "ssh-key" {
  algorithm = "ED25519"
}

resource "local_file" "public_key" {
  filename = "~/.ssh/tofu-ssh.pub"
  content  = tls_private_key.ssh-key.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "~/.ssh/tofu-ssh"
  content  = tls_private_key.ssh-key.private_key_openssh
}
