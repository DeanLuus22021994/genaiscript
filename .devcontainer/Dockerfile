ARG NODE_VERSION=20
FROM mcr.microsoft.com/devcontainers/javascript-node:${NODE_VERSION}

# Version arguments
ARG PYTHON_VERSION=3.11
ARG RUNNER_VERSION=2.323.0
ARG ACT_VERSION=0.2.60

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install additional OS packages
RUN apt-get update && apt-get -y install --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    jq \
    graphviz \
    fonts-noto-color-emoji \
    build-essential \
    curl \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install specific Python version if needed
RUN if [ "${PYTHON_VERSION}" != "default" ]; then \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python${PYTHON_VERSION}-dev \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1; \
    fi

# Install global npm packages
RUN npm install -g npm@latest typescript@latest ts-node@latest

# Setup global Yarn cache to improve rebuilds
RUN mkdir -p /usr/local/share/.cache/yarn && \
    chown -R node:node /usr/local/share/.cache/yarn

# Set up pnpm
RUN npm install -g pnpm@latest

# Install pip packages globally
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Install GitHub Actions runner
RUN mkdir -p /opt/actions-runner && cd /opt/actions-runner \
    && curl -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf runner.tar.gz \
    && rm runner.tar.gz \
    && ./bin/installdependencies.sh \
    && chown -R node:node /opt/actions-runner

# Install nektos/act for local GitHub Actions testing
RUN curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- v${ACT_VERSION}

# Setup script that will run at container startup
COPY .devcontainer/scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# Configure Git to handle line endings
RUN git config --system core.autocrlf input

# Set user to avoid permission issues with bind mounts
USER node

# Prepare directory structure for settings sync
RUN mkdir -p /home/node/.config/Code/User/globalStorage \
    /home/node/.config/Code/User/sync \
    /home/node/.config/Code\ -\ Insiders/User/globalStorage \
    /home/node/.config/Code\ -\ Insiders/User/sync

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
