resource "aws_security_group" "example" {
  name        = "example"
  description = "example security group"
  vpc_id      = "${aws_vpc.example.id}"

  tags = {
    Name = "example"
  }
}
