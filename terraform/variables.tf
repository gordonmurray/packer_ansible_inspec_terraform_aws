# Variables used
variable "region" {
  // AWS region to deploy into; also honours AWS_REGION
  type    = string
  default = "eu-west-1"
}

variable "aws_account_id" {
  // read from terraform.tfvars
  type = string
}

variable "default_instance_type" {
  // read from terraform.tfvars
  type = string
}

variable "default_region" {
  // read from terraform.tfvars
  type = string
}

variable "apply_immediately" {
  // read from terraform.tfvars
  type    = string
  default = "false"
}

variable "encryption_at_rest" {
  // read from terraform.tfvars
  type    = string
  default = "true"
}
