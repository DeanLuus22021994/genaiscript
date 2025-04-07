#!/bin/bash

# VS Code Settings Sync Helper Script
echo "📁 Setting up VS Code settings sync..."

# For VS Code stable
if [ -d "$HOME/.config/Code/User" ]; then
  mkdir -p "$HOME/.config/Code/User/globalStorage"
  mkdir -p "$HOME/.config/Code/User/sync"
elif [ -d "$HOME/Library/Application Support/Code/User" ]; then
  mkdir -p "$HOME/Library/Application Support/Code/User/globalStorage"
  mkdir -p "$HOME/Library/Application Support/Code/User/sync" 
elif [ -d "$HOME/AppData/Roaming/Code/User" ]; then
  mkdir -p "$HOME/AppData/Roaming/Code/User/globalStorage"
  mkdir -p "$HOME/AppData/Roaming/Code/User/sync"
fi

# For VS Code Insiders
if [ -d "$HOME/.config/Code - Insiders/User" ]; then
  mkdir -p "$HOME/.config/Code - Insiders/User/globalStorage"
  mkdir -p "$HOME/.config/Code - Insiders/User/sync"
elif [ -d "$HOME/Library/Application Support/Code - Insiders/User" ]; then
  mkdir -p "$HOME/Library/Application Support/Code - Insiders/User/globalStorage"
  mkdir -p "$HOME/Library/Application Support/Code - Insiders/User/sync"
elif [ -d "$HOME/AppData/Roaming/Code - Insiders/User" ]; then
  mkdir -p "$HOME/AppData/Roaming/Code - Insiders/User/globalStorage"
  mkdir -p "$HOME/AppData/Roaming/Code - Insiders/User/sync"
fi

echo "✅ VS Code settings sync directories prepared!"
