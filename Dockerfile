# Pinned toolchain for building and checking this project, so local runs
# match CI. Build with `make tools-build`, then `make shell`.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TERRAFORM_VERSION=1.10.5 \
    PACKER_VERSION=1.11.2 \
    TFLINT_VERSION=0.53.0 \
    TRIVY_VERSION=0.58.0 \
    INFRACOST_VERSION=0.10.44 \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl unzip git python3 python3-pip pipx \
    && rm -rf /var/lib/apt/lists/*

# Terraform
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/tf.zip \
    && unzip -o /tmp/tf.zip -d /usr/local/bin && rm /tmp/tf.zip

# Packer
RUN curl -fsSL "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" -o /tmp/pk.zip \
    && unzip -o /tmp/pk.zip -d /usr/local/bin && rm /tmp/pk.zip

# tflint
RUN curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" -o /tmp/tflint.zip \
    && unzip -o /tmp/tflint.zip -d /usr/local/bin && rm /tmp/tflint.zip

# Trivy
RUN curl -fsSL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
    | sh -s -- -b /usr/local/bin "v${TRIVY_VERSION}"

# Ansible + ansible-lint (pipx keeps them off the PEP 668 system Python)
RUN pipx install --include-deps ansible && pipx install ansible-lint

# CINC Auditor (the open-source InSpec distribution)
RUN curl -fsSL https://omnitruck.cinc.sh/install.sh | bash -s -- -P cinc-auditor

# Infracost (cost estimates; needs an API key at runtime)
RUN curl -fsSL "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz" -o /tmp/ic.tgz \
    && tar -xzf /tmp/ic.tgz -C /tmp && mv /tmp/infracost-linux-amd64 /usr/local/bin/infracost && rm /tmp/ic.tgz

WORKDIR /work
CMD ["bash"]
