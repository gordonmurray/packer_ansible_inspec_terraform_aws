IMAGE ?= packer-ansible-inspec-terraform-aws-tools
TF    := terraform -chdir=terraform

.PHONY: help fmt fmt-check validate test tflint ansible-lint packer-validate lint cost tools-build shell

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

fmt: ## Format the Terraform
	$(TF) fmt

fmt-check: ## Check Terraform formatting
	$(TF) fmt -check

validate: ## Init (no backend) and validate the Terraform
	$(TF) init -backend=false -input=false -lockfile=readonly
	$(TF) validate

# The AWS provider is mocked, so this needs no credentials. The key is only
# there because terraform test evaluates file(), unlike terraform validate.
test: ## Run the plan-level Terraform tests (no AWS access needed)
	@mkdir -p terraform/tests/fixtures
	@test -f terraform/tests/fixtures/id_rsa.pub || \
		ssh-keygen -t ed25519 -N "" -C ci -f terraform/tests/fixtures/id_rsa
	$(TF) test

tflint: ## Lint the Terraform
	cd terraform && tflint --init && tflint --config=$(CURDIR)/.tflint.hcl

ansible-lint: ## Lint the Ansible
	ansible-lint ansible/

packer-validate: ## Validate the Packer template
	cd packer && packer init . && packer validate .

lint: tflint ansible-lint ## Run all linters

cost: ## Estimate the monthly cost with infracost
	infracost breakdown --path terraform

tools-build: ## Build the pinned toolchain image
	docker build -t $(IMAGE) .

shell: tools-build ## Open a shell in the toolchain image
	docker run --rm -it -v "$(CURDIR)":/work -w /work $(IMAGE) bash
