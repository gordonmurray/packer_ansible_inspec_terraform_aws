resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.example.id}"

  tags = {
    Name = "example"
  }
}

resource "aws_route" "route-table" {
  route_table_id         = "${aws_route_table.route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
  depends_on             = ["aws_route_table.route-table"]
}