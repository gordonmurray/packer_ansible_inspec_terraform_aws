# Packer, Ansible, CINC Auditor and Terraform on AWS

A small, working demo of [Packer](https://www.packer.io/),
[Ansible](https://www.ansible.com/), [CINC Auditor](https://cinc.sh/) (the
open-source InSpec) and [Terraform](https://www.terraform.io/) used together on
AWS.

The end result is a "Hello World" PHP page served by nginx on a single EC2
instance in its own VPC.

- **Packer** builds an Amazon Machine Image (AMI).
- **Ansible** runs inside Packer to install nginx and PHP and configure the site.
- **CINC Auditor** runs inside Packer to verify the image looks the way we expect.
- **Terraform** creates a small VPC and launches an EC2 instance from that AMI.

## What you need

- An AWS account, with credentials available to your shell (see below).
- [Packer](https://developer.hashicorp.com/packer) >= 1.7
- [Terraform](https://developer.hashicorp.com/terraform) >= 1.0
- [CINC Auditor](https://cinc.sh/start/auditor/) — only if you want to run the
  checks outside Packer.

Or skip installing them and use the pinned toolchain image, which has matching
versions of everything:

```sh
make tools-build
make shell
```

## AWS credentials

Packer and Terraform both use the standard AWS credential chain, so set a
profile (or the usual `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`) before you
start:

```sh
export AWS_PROFILE=your-profile
export AWS_REGION=eu-west-1
```

Use an identity that can manage EC2 and VPC resources. Prefer a least-privilege
IAM role or AWS IAM Identity Center (SSO) over long-lived access keys.

## Build the AMI

```sh
cd packer
packer init .
packer validate .
packer build .
```

This builds from the latest Ubuntu 24.04 LTS, runs the Ansible roles, and
verifies the result with CINC Auditor.

## Deploy with Terraform

```sh
cd terraform
cp terraform.tfvars.example terraform.tfvars   # then set aws_account_id
terraform init
terraform apply
```

`aws_account_id` is the account that owns the AMI Packer built. The instance's
public DNS is printed as an output — open it in a browser to see the page.

### Optional variables

- `region` — defaults to `eu-west-1` (or set `AWS_REGION`).
- `default_instance_type` — defaults to `t3.micro`.
- `ssh_public_key_path` — public key for the EC2 key pair, defaults to
  `~/.ssh/id_rsa.pub`.
- `ssh_cidr` — set to a CIDR to open SSH (port 22) to just that range. Empty by
  default, so no SSH rule is created.

## Checks

```sh
make fmt-check    # terraform fmt
make validate     # terraform validate
make lint         # tflint + ansible-lint
```

CI runs the same checks on every pull request. There's also a
[pre-commit](https://pre-commit.com/) config:

```sh
pre-commit install
```

## Clean up

```sh
cd terraform
terraform destroy
```

To remove the AMI, deregister it from the EC2 console or with the AWS CLI.

## License

[MIT](LICENSE)
