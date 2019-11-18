# route53 zones
resource "aws_route53_zone" "example_zone" {
  name = "myexample.com"
}