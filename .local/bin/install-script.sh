#!/bin/bash

# Check if a repository URL is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 repo_url"
  exit 1
fi

repo_url=$1

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a /var/log/install_packages.log
}

# Update package list
log "Updating package list"
if sudo pacman -Syu --noconfirm; then
  log "Package list updated successfully"
else
  log "Failed to update package list"
  exit 1
fi

# Install git if not already installed
if ! pacman -Qi git >/dev/null 2>&1; then
  if sudo pacman -S --noconfirm git; then
    log "git installed successfully"
  else
    log "Failed to install git"
    exit 1
  fi
else
  log "git is already installed"
fi

# Clone the repository
repo_name=$(basename "$repo_url" .git)
log "Cloning $repo_url"
if git clone "$repo_url"; then
  log "$repo_url cloned successfully"
  cd "$repo_name" || exit 1
  # Execute installation commands if there are any
  if [ -f "install.sh" ]; then
    log "Running install.sh for $repo_name"
    if bash install.sh; then
      log "install.sh for $repo_name executed successfully"
    else
      log "install.sh for $repo_name failed"
    fi
  else
    log "No install.sh found for $repo_name"
    # If there's no install.sh, you can add custom commands here
    # For example, if you need to link dotfiles, you can do it here:
    if [ -d "$HOME/.config" ]; then
      log "Linking dotfiles"
      for file in .??*; do
        [ "$file" = ".git" ] && continue
        ln -svf "$PWD/$file" "$HOME/$file"
        log "Linked $file to $HOME/$file"
      done
    else
      log "No .config directory found in the home directory"
    fi
  fi
  cd ..
else
  log "Failed to clone $repo_url"
  exit 1
fi

log "Repository installation script completed"
