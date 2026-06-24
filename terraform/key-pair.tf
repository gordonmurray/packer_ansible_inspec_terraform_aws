resource "aws_key_pair" "pem-key" {
  key_name   = "example"
  public_key = file(pathexpand(var.ssh_public_key_path))
}
