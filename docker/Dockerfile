FROM debian:bookworm-slim

# setting version
ARG TERRAFORM_VERSION="1.10.4"
ARG AWS_CLI_VERSION="2.22.33"
ARG AZ_CLI_VERSION="2.67.0"
ARG GCLOUD_VERSION="505.0.0"

# install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  ssh \
  bash \
  less \
  curl \
  wget \
  unzip \
  jq \
  python3 \
  python3-pip \
  python3-venv \
  git \
  make \
  gcc \
  libc-dev \
  openssl \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# install mise
RUN curl https://mise.run | sh \
  && echo 'eval "$(~/.local/bin/mise activate bash)"' >> /root/.bashrc

# Copy mise configuration
COPY .mise.toml ./.mise.toml

# Install tools via mise
RUN PATH=$PATH:/root/.local/bin \
  && mise trust ./.mise.toml \
  && mise install

WORKDIR /workspace
CMD ["/bin/bash"]
