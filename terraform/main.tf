# Credentials and profile come from the environment (AWS_PROFILE / the
# standard AWS credential chain). Region defaults to eu-west-1 but can be
# overridden with the region variable or AWS_REGION.
provider "aws" {
  region = var.region
}
