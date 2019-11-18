resource "aws_route53_record" "example_cname" {
  zone_id = "${aws_route53_zone.example_zone.zone_id}"
  name    = "www.myexample.com"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_instance.example.public_dns}"]
}