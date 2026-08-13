# Plan-level tests. The AWS provider is mocked, so this runs a real plan without
# AWS credentials. The point is to catch a provider upgrade that changes a
# default or drops an argument before it reaches a real apply, and to keep the
# choices below from being undone by accident.
#
# `terraform test` evaluates file(), which `terraform validate` does not, so
# ssh_public_key_path points at a throwaway key instead of the ~/.ssh default.
# `make test` generates it.

mock_provider "aws" {}

variables {
  aws_account_id      = "123456789012"
  ssh_public_key_path = "tests/fixtures/id_rsa.pub"
}

run "the_instance_is_hardened" {
  command = plan

  assert {
    condition     = aws_instance.example.metadata_options[0].http_tokens == "required"
    error_message = "The instance must require IMDSv2"
  }

  assert {
    condition     = aws_instance.example.root_block_device[0].encrypted
    error_message = "The root volume must be encrypted"
  }

  assert {
    condition     = aws_instance.example.instance_type == var.default_instance_type
    error_message = "The instance type must come from the variable, not be hardcoded"
  }
}

run "ssh_is_closed_unless_asked_for" {
  command = plan

  # ssh_cidr defaults to "", which builds no SSH rule at all. Port 80 is public
  # on purpose — this is a hello-world web server.
  assert {
    condition     = length(aws_security_group_rule.ssh) == 0
    error_message = "No SSH rule should exist while ssh_cidr is empty"
  }

  assert {
    condition     = contains(aws_security_group_rule.example.cidr_blocks, "0.0.0.0/0") && aws_security_group_rule.example.from_port == 80
    error_message = "The public rule should be HTTP and nothing else"
  }
}

run "ssh_opens_only_to_the_given_cidr" {
  command = plan

  variables {
    ssh_cidr = "203.0.113.10/32"
  }

  assert {
    condition     = length(aws_security_group_rule.ssh) == 1
    error_message = "Setting ssh_cidr should create exactly one SSH rule"
  }

  assert {
    condition     = aws_security_group_rule.ssh[0].cidr_blocks == tolist([var.ssh_cidr])
    error_message = "The SSH rule must be scoped to ssh_cidr and nothing wider"
  }
}

run "the_subnets_follow_the_region" {
  command = plan

  # The availability zones are written out in full, so changing the region
  # without changing them leaves the subnets pointing at another region.
  assert {
    condition = alltrue([
      for s in [aws_subnet.subnet-1a, aws_subnet.subnet-1b] :
      startswith(s.availability_zone, var.region)
    ])
    error_message = "The subnet availability zones must be in the configured region"
  }
}
