#!/bin/bash
set -e

echo "Setting up mac dev tools..."

# Make sure Xcode Command Line Tools are installed
xcode-select --install 2>/dev/null || true

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed"
fi

# Update & upgrade brew
brew update && brew upgrade

echo "Installing CLI tools..."
brew install \
  awscli \
  google-cloud-sdk \
  curl \
  grep \
  node \
  python@3.11 \
  postgresql \
  terraform

# Install Docker (desktop app)
brew install --cask docker

# Install frontend frameworks
npm install -g \
  typescript \
  create-next-app \
  react \
  yarn \
  next@latest

# Install python packages
pip install \
  django \
  django-admin

echo "Installing apps..."
brew install --cask \
  visual-studio-code \
  postman \
  pgadmin4 \
  tailscale \
  1password


echo "Setup complete"