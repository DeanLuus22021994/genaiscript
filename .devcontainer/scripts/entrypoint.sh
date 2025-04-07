#!/bin/bash
set -e

# Source Node.js version manager
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Source custom environment variables if available
if [ -f "$HOME/.env" ]; then
  set -a
  . "$HOME/.env"
  set +a
fi

# Handle SSH keys from host if they exist
if [ -d "$HOME/.ssh-host" ] && [ -f "$HOME/.ssh-host/id_rsa" ]; then
  mkdir -p "$HOME/.ssh"
  cp -r "$HOME/.ssh-host/"* "$HOME/.ssh/"
  chmod 700 "$HOME/.ssh"
  chmod 600 "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_rsa.pub" 2>/dev/null || true
  chmod 600 "$HOME/.ssh/config" 2>/dev/null || true
fi

# Configure git user from environment variables
if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
  git config --global user.name "$GIT_USER_NAME"
  git config --global user.email "$GIT_USER_EMAIL"
fi

# If a command was provided, execute it, otherwise start a shell
if [ $# -gt 0 ]; then
  exec "$@"
else
  # Start interactive shell
  if [ -f "$HOME/.zshrc" ]; then
    exec zsh -i
  else
    exec bash -i
  fi
fi
