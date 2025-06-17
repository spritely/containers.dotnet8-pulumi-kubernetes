# 1. List of all available tags: https://mcr.microsoft.com/product/dotnet/sdk/tags
# 2. Details about selecting a container image: https://github.com/dotnet/dotnet-docker/blob/main/README.sdk.md
# 3. Ubuntu releases: https://www.releases.ubuntu.com/
# 4. Information on dotnet versions: https://dotnet.microsoft.com/en-us/download/dotnet
# Also see:
# - .NET tagging policy: https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-tags.md
# - .NET image variants: https://github.com/dotnet/dotnet-docker/blob/main/documentation/image-variants.md

# Starting point for this file: https://github.com/devcontainers/images/blob/main/src/dotnet/.devcontainer/Dockerfile

# To find an image tag from #1:
# - Use the linux amd64 variant from #2
# - Choose latest long-term-support (LTS) version of Ubuntu from #3
# - Select the latest dotnet version from #4 that exists in #1
FROM mcr.microsoft.com/dotnet/sdk:8.0.406-noble-amd64

# Clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# See https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=

RUN apt-get update && apt-get install -y openssh-client \
    # Install Azure CLI, see: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    bats \
    git \
    wget && \
    # The version of yq available in apt is very outdated so it must be manually installed
    # To find newer versions visit: https://github.com/mikefarah/yq/releases/
    wget https://github.com/mikefarah/yq/releases/download/v4.45.4/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq \
    && mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && AZ_DIST=$(lsb_release -cs) \
    # Obtain the version number from: https://learn.microsoft.com/en-us/cli/azure/release-notes-azure-cli
    # Only use the major, minor, and patch version numbers
    && AZ_VER=2.72.0 \
    && echo "Types: deb\nURIs: https://packages.microsoft.com/repos/azure-cli/\nSuites: ${AZ_DIST}\nComponents: main\nArchitectures: $(dpkg --print-architecture)\nSigned-by: /etc/apt/keyrings/microsoft.gpg" | tee /etc/apt/sources.list.d/azure-cli.sources \
    && apt-get update && apt-get install -y azure-cli=${AZ_VER}-1~${AZ_DIST} \
    # Install Pulumi CLI, see: https://www.pulumi.com/docs/install/
    # To find a new version check this page: https://www.pulumi.com/docs/install/versions/
    && curl -fsSL https://get.pulumi.com | sh -s -- --version 3.170.0 \
    # Install kubectl CLI, see: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    # KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    # KUBECTL_VERSION will be something like v1.32.2 but commands below require the minor version only
    && KUBECTL_MINOR_VERSION=v1.33 \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl jq yq

ENV PATH="/root/.pulumi/bin:${PATH}"

ENV PULUMI_SKIP_UPDATE_CHECK=true
