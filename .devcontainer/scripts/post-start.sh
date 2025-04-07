#!/bin/bash
set -e

echo "🚀 Running post-start setup..."

# Run the settings sync script
if [ -f ".devcontainer/scripts/sync-settings.sh" ]; then
  echo "⚙️ Syncing VS Code settings..."
  bash .devcontainer/scripts/sync-settings.sh
fi

# Check for dotfiles updates
if [ -d "$HOME/dotfiles" ] && [ -d "$HOME/dotfiles/.git" ]; then
  echo "🔄 Checking for dotfiles updates..."
  (cd "$HOME/dotfiles" && git pull --quiet) || echo "⚠️ Could not update dotfiles."
fi

# Check for package updates
if [ -f "package.json" ]; then
  echo "📦 Checking for outdated dependencies..."
  # Store outdated packages in a file for reference, but don't update automatically
  if [ -f "yarn.lock" ]; then
    yarn outdated --color > "$HOME/.yarn-outdated" 2>/dev/null || true
  elif [ -f "pnpm-lock.yaml" ]; then
    pnpm outdated > "$HOME/.pnpm-outdated" 2>/dev/null || true
  else
    npm outdated > "$HOME/.npm-outdated" 2>/dev/null || true
  fi
fi

# Set up cross-platform environment variables
if [ ! -f "$HOME/.env" ]; then
  echo "🌐 Setting up cross-platform environment..."
  touch "$HOME/.env"
  
  # Add DISPLAY variable for GUI applications if running on Linux
  if [ -n "$DISPLAY" ]; then
    grep -q "DISPLAY" "$HOME/.env" || echo "DISPLAY=$DISPLAY" >> "$HOME/.env"
  fi
  
  # Set editor preferences
  grep -q "EDITOR" "$HOME/.env" || echo "EDITOR=code" >> "$HOME/.env"
  
  # Set Git editor
  git config --global core.editor "code --wait"
fi

# Check and setup GitHub CLI authentication
if command -v gh &> /dev/null; then
  echo "🔑 Checking GitHub CLI authentication..."
  if ! gh auth status &>/dev/null; then
    echo "⚠️ GitHub CLI not authenticated. Use 'gh auth login' if needed."
  fi
fi

# Ensure node_modules is properly linked if using Docker volume
if [ -f "package.json" ] && command -v docker &> /dev/null; then
  echo "📁 Checking node_modules mount..."
  if [ ! -d "node_modules" ] || [ -L "node_modules" ]; then
    echo "⚠️ node_modules is not properly set up. This might be normal if you haven't installed dependencies yet."
  fi
fi

# Check for Docker health
if command -v docker &> /dev/null; then
  echo "🐳 Checking Docker status..."
  docker info &>/dev/null || echo "⚠️ Docker is not running or not accessible."
fi

# Create a welcome message with useful commands
cat > "$HOME/.welcome-message" << 'WELCOME'
Welcome to the GenAIScript Development Environment!

🔮 Quick Commands:
  - run a GenAI script: node packages/cli/built/genaiscript.cjs run [script-path]
  - git commit flow: run VS Code task "gcm"
  - generate image alt text: run VS Code task "iat"

🔧 GitHub Actions Tools:
  - Setup self-hosted runner: .devcontainer/scripts/actions/setup-runner.sh --url [REPO_URL] --token [TOKEN]
  - Run actions locally: .devcontainer/scripts/actions/run-action-locally.sh --workflow [WORKFLOW_FILE]
  - Example: .devcontainer/scripts/actions/run-action-locally.sh --workflow .github/workflows/ci.yml

📚 Documentation: See README.md or docs/ directory

🛠️ Troubleshooting:
  - Container issues: Rebuild container from VS Code
  - Dependency issues: yarn install --frozen-lockfile
  - Git issues: Ensure proper authentication with GitHub
  - Actions issues: Make sure Docker is running for act to work properly

WELCOME

# Print the welcome message
echo "📊 Development environment ready!"
cat "$HOME/.welcome-message"

echo "✅ Post-start setup complete!"
