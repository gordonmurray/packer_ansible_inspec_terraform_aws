# Variables used
variable "aws_account_id" {
  // read from terraform.tfvars
  type = "string"
}

variable "default_instance_type" {
  // read from terraform.tfvars
  type = "string"
}

variable "default_region" {
  // read from terraform.tfvars
  type = "string"
}

variable "apply_immediately" {
  // read from terraform.tfvars
  type    = "string"
  default = "false"
}

variable "encryption_at_rest" {
  // read from terraform.tfvars
  type    = "string"
  default = "true"
}
