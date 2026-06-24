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
make lint
```

CI runs the same checks. The `terraform` job has to pass before a PR can merge.

## Pull requests

- Branch off `main`, one change per PR.
- Reference the issue it closes (for example `Closes #123`).
- Keep commits focused and the description short.
