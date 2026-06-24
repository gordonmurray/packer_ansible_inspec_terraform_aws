# Variables used
variable "region" {
  // AWS region to deploy into; also honours AWS_REGION
  type    = string
  default = "eu-west-1"
}

variable "aws_account_id" {
  // owner of the AMI built by Packer; read from terraform.tfvars
  type = string
}

variable "default_instance_type" {
  // EC2 instance type; override in terraform.tfvars
  type    = string
  default = "t3.micro"
}

variable "ssh_public_key_path" {
  // your own public key, used for the EC2 key pair
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_cidr" {
  // CIDR allowed to SSH in; empty means no SSH rule is created
  type    = string
  default = ""
}
