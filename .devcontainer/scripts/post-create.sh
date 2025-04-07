#!/bin/bash
set -e

echo "🚀 Running post-creation setup..."

# Install dependencies based on package manager in repository
if [ -f "package.json" ]; then
  if [ -f "yarn.lock" ]; then
    echo "📦 Installing dependencies with Yarn..."
    yarn install --frozen-lockfile --prefer-offline
  elif [ -f "pnpm-lock.yaml" ]; then
    echo "📦 Installing dependencies with pnpm..."
    pnpm install --frozen-lockfile
  else
    echo "📦 Installing dependencies with npm..."
    npm ci
  fi
fi

# Install Playwright if needed
if grep -q "playwright" package.json; then
  echo "🎭 Installing Playwright browsers..."
  yarn install:playwright || npx playwright install --with-deps
fi

# Install FFMPEG if needed
if grep -q "ffmpeg" package.json; then
  echo "🎬 Installing FFMPEG..."
  yarn ffmpeg:install || npm run ffmpeg:install || echo "⚠️ Could not install FFMPEG automatically."
fi

# Setup Python environment if needed
if [ -f "requirements.txt" ]; then
  echo "🐍 Setting up Python environment..."
  python -m pip install --upgrade pip
  python -m pip install -r requirements.txt
fi

# Initialize git hooks if needed
if [ -d ".git" ] && [ -d ".husky" ]; then
  echo "🪝 Setting up git hooks..."
  npx husky install || echo "⚠️ Could not set up Husky git hooks."
fi

# Setup environment variables from example files
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  echo "🔑 Setting up environment variables..."
  cp .env.example .env
  echo "⚠️ Don't forget to update the .env file with your actual values."
fi

# Create named volume for node_modules to improve performance (especially on Windows)
if [ -f "package.json" ] && command -v docker &> /dev/null; then
  echo "🗄️ Setting up persistent node_modules volume..."
  REPO_NAME=$(basename $(pwd))
  if ! docker volume ls | grep -q "${REPO_NAME}_node_modules"; then
    docker volume create "${REPO_NAME}_node_modules" &>/dev/null || true
  fi
fi

# Ensure proper Git line ending configuration
git config --global core.autocrlf input

# Build any necessary components
echo "🔨 Building project components..."
if [ -f "yarn.lock" ]; then
  yarn build || echo "⚠️ Build command failed or not available."
elif [ -f "pnpm-lock.yaml" ]; then
  pnpm run build || echo "⚠️ Build command failed or not available."
else
  npm run build || echo "⚠️ Build command failed or not available."
fi

# Initialize GPG keys if available
if [ -d "$HOME/.gnupg-host" ]; then
  echo "🔐 Setting up GPG keys..."
  mkdir -p "$HOME/.gnupg"
  cp -r "$HOME/.gnupg-host/"* "$HOME/.gnupg/"
  chmod 700 "$HOME/.gnupg"
  find "$HOME/.gnupg" -type f -exec chmod 600 {} \;
  find "$HOME/.gnupg" -type d -exec chmod 700 {} \;
fi

# Set up default browser for development
if command -v xdg-mime &> /dev/null; then
  echo "🌐 Configuring default browser..."
  xdg-mime default firefox.desktop text/html
fi

# Support for Azure authentication if needed
if command -v az &> /dev/null; then
  echo "☁️ Checking Azure CLI authentication..."
  az account show &>/dev/null || echo "⚠️ Azure CLI not authenticated. Use 'az login' if needed."
fi

# Generate any necessary files
for GENAI_FILE in $(find genaisrc -name "*.genai.*" -not -path "*/node_modules/*" 2>/dev/null); do
  if [ -f "packages/cli/built/genaiscript.cjs" ]; then
    echo "🧠 Running GenAI script: $GENAI_FILE"
    node packages/cli/built/genaiscript.cjs run "$GENAI_FILE" || echo "⚠️ Could not run $GENAI_FILE"
  fi
done

echo "✅ Post-creation setup complete!"
