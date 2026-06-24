packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1.1"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

# Credentials come from the standard AWS chain (AWS_PROFILE / env vars).
source "amazon-ebs" "server" {
  region        = var.region
  instance_type = var.instance_type
  ssh_username  = "ubuntu"
  ami_name      = "example"

  # Resolve the latest Ubuntu 24.04 LTS from Canonical at build time.
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  force_deregister      = true
  force_delete_snapshot = true

  tags = {
    Name = "example.com"
  }
}

build {
  sources = ["source.amazon-ebs.server"]

  provisioner "shell" {
    inline = [
      "sudo apt-add-repository ppa:ansible/ansible",
      "sudo apt update",
      "sudo apt install ansible -y",
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "../ansible/server.yml"
    role_paths = [
      "../ansible/roles/nginx",
      "../ansible/roles/php",
      "../ansible/roles/permissions",
    ]
    group_vars = "../ansible/group_vars"
  }

  provisioner "file" {
    source      = "../ansible/roles/nginx/templates/default"
    destination = "/home/ubuntu/default"
  }

  provisioner "shell" {
    inline = ["sudo mv /home/ubuntu/default /etc/nginx/sites-available/default"]
  }

  provisioner "file" {
    source      = "../app/php/src/index.php"
    destination = "/var/www/html/"
  }

  # Verify the build with CINC Auditor (the open-source InSpec).
  provisioner "file" {
    source      = "../inspec"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline = [
      "curl -fsSL https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-auditor",
      "sudo cinc-auditor exec /tmp/inspec",
    ]
  }
}
