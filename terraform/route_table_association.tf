resource "aws_route_table_association" "route-table-a" {
  subnet_id      = "${aws_subnet.subnet-1a.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_route_table_association" "route-table-b" {
  subnet_id      = "${aws_subnet.subnet-1b.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}
