#!/usr/bin/env bash

# Set variables
CONFIG_DIR="/etc/nixos"
BACKUP_DIR="$HOME/Documents/repos/nix-config"
GITHUB_REPO="https://github.com/tmunongo/nix-config.git"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Copy NixOS configuration
cp -r "$CONFIG_DIR"/* "$BACKUP_DIR/"

# Change to backup directory
cd "$BACKUP_DIR" || exit

# Initialize git repo if it doesn't exist
if [ ! -d .git ]; then
    git init
    git remote add origin "$GITHUB_REPO"
fi

# Commit changes
git add .
git commit -m "Automated backup $(date +'%Y-%m-%d %H:%M:%S')"

# Push to GitHub
git push -u origin main
