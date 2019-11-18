resource "aws_subnet" "subnet-1a" {
  vpc_id                  = "${aws_vpc.example.id}"
  availability_zone       = "eu-west-1a"
  cidr_block              = "100.10.0.0/20"
  ipv6_cidr_block         = ""
  map_public_ip_on_launch = "true"

  tags = {
    Name = "example"
  }
}

resource "aws_subnet" "subnet-1b" {
  vpc_id = "${aws_vpc.example.id}"

  availability_zone       = "eu-west-1b"
  cidr_block              = "100.10.16.0/20"
  ipv6_cidr_block         = ""
  map_public_ip_on_launch = "true"

  tags = {
    Name = "example"
  }
}