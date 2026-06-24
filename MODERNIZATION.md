# Modernization notes

This demo dates from 2019 and had stopped working on current tooling. This pass
brought it back to life and tidied it up.

## Make it runnable again

- Updated the Terraform from 0.11-era syntax to 1.x: dropped quoted type
  constraints and `${...}` interpolation, fixed `depends_on`, and removed the
  invalid empty `ipv6_cidr_block`.
- Added a `terraform {}` block pinning the AWS provider.
- The provider now reads credentials and region from the environment
  (`AWS_PROFILE` / `AWS_REGION`) instead of a hardcoded profile.
- Removed unused variables and added `terraform.tfvars.example`.

## Project scaffolding

- Makefile, pre-commit config, tflint config, `.editorconfig`, CODEOWNERS.
- CONTRIBUTING and SECURITY docs, issue and PR templates.
- A pinned toolchain Dockerfile so local checks match CI.
- A CI workflow that runs `terraform fmt`/`validate`, tflint, ansible-lint,
  `packer validate` and a Trivy config scan on every pull request.
- Dependabot for GitHub Actions, Terraform and Docker.

## Security

- Replaced the deprecated tfsec workflow with Trivy.
- Encrypted the EC2 root volume and required IMDSv2.
- Stopped shipping a personal SSH key; the key pair now reads your own public
  key from a variable.
- Added an optional, CIDR-restricted SSH ingress rule (off by default).

## The stack

- Converted the Packer template from legacy JSON to HCL2 with `required_plugins`.
- Build from the latest Ubuntu 24.04 LTS via a `source_ami_filter` instead of a
  dead hardcoded AMI.
- Install Ansible from the distro rather than a PPA.
- Ansible roles use fully-qualified module names and pinned package state.
- The nginx config is templated to the installed PHP version, so it no longer
  points at the long-gone PHP 7.2 socket.
- Verification moved from InSpec (now commercially licensed) to CINC Auditor.

## Correctness and docs

- Removed the Route53 hosted zone and CNAME (a domain nobody owns, ~$0.50/month).
- Defaulted to a current-generation `t3.micro` instance.
- Rewrote the README.
