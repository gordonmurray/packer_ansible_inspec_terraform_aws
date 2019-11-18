resource "aws_key_pair" "pem-key" {
  key_name   = "example"
  public_key = "${file("files/id_rsa.pub")}"
}