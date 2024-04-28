terraform {
  backend "s3" {
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "main" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  key_name = aws_key_pair.admin_gen_key.key_name

  provisioner "file" {
    content     = templatefile("../scripts/init.tpl", { public_key = tls_private_key.admin.public_key_openssh })
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.admin.private_key_pem
    timeout     = "4m"
  }

  tags = {
    Name         = "${var.environment}_freqtrade"
    environment  = var.environment
    project      = var.project
    organization = var.organization
  }
}

resource "tls_private_key" "admin" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "admin_gen_key" {
  key_name   = "${var.environment}_ec2_admin_key"
  public_key = tls_private_key.admin.public_key_openssh
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.environment}_allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "AnsibleInventory" {
  filename = "../ansible/inventory.ini"
  content  = "[servers]\n${aws_instance.main.public_ip} ansible_ssh_user=ansible ansible_ssh_private_key_file=~/.ssh/${var.environment}_ec2_admin_key.pem"
}
