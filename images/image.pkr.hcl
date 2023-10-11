variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
locals {
  instance_type = "t3.micro"
}

data "amazon-ami" "ubuntu20" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
  region      = "ap-northeast-2"
}

data "amazon-ami" "ubuntu22" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
  region      = "ap-northeast-2"
}

source "amazon-ebs" "packer" {
  access_key           = var.aws_access_key
  secret_key           = var.aws_secret_key
  ami_name             = "packer_ami_{{timestamp}}"
  instance_type        = local.instance_type
  region               = "ap-northeast-2"
  source_ami           = data.amazon-ami.ubuntu22.id
  ssh_username         = "ubuntu"
  communicator         = "ssh"
  iam_instance_profile = "hmkimssmcwagent"
}

build {
  sources = ["source.amazon-ebs.packer"]
  provisioner "file" {
    source      = "../scripts/install_ssm.sh"
    destination = "/tmp/install_ssm.sh"
  }
  provisioner "file" {
    source      = "../scripts/install_cw.sh"
    destination = "/tmp/install_cw.sh"
  }
  provisioner "shell" {
    inline = [
      "sh /tmp/install_ssm.sh",
      "sh /tmp/install_cw.sh",
      ]
  }
}