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
  // EC2 instance type; read from terraform.tfvars
  type = string
}
