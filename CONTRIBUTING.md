# Contributing

Thanks for taking a look. This repo is a demo of Packer, Ansible, CINC Auditor
and Terraform working together on AWS.

## Getting set up

You'll need the tools listed in the README, or just use the pinned toolchain
image so your versions match CI:

```sh
make tools-build
make shell
```

## Checks

Before opening a pull request, run:

```sh
make fmt-check
make validate
make test
make lint
```

CI runs the same checks. The `terraform` and `terraform-test` jobs have to pass before a PR
can merge.

`terraform/.terraform.lock.hcl` is committed and `init` runs with `-lockfile=readonly`, so the
provider version is the same everywhere. It carries hashes for linux and macOS on both amd64
and arm64. If you are on something else, or you change the provider requirement, refresh it:

```sh
cd terraform
terraform providers lock \
  -platform=linux_amd64 -platform=linux_arm64 \
  -platform=darwin_amd64 -platform=darwin_arm64
```

## Pull requests

- Branch off `main`, one change per PR.
- Reference the issue it closes (for example `Closes #123`).
- Keep commits focused and the description short.
