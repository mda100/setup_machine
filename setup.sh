#!/bin/bash
set -e

echo "Setting up mac dev tools..."

echo "Installing xcode..."
xcode-select --install 2>/dev/null || true

if ! command -v brew &> /dev/null; then
  echo "Homebrew already installed"
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for this session
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Persist brew in shell startup
  'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  source ~/.zshrc

else
  echo "✅ Homebrew already installed"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
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
  terraform \
  gh \
  1password-cli

echo "Installing npm packages..."
npm install -g \
  typescript \
  create-next-app \
  react \
  yarn \
  next@latest

echo "Installing apps..."
brew install --cask \
  visual-studio-code \
  postman \
  pgadmin4 \
  tailscale \
  1password \
  docker

echo "Configuring Git..."

read -p "Enter your GitHub username: " gh_user
read -p "Enter your GitHub email: " gh_email

git config --global user.name "$gh_user"
git config --global user.email "$gh_email"
git config --global init.defaultBranch main

if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  echo "Generating SSH key..."
  ssh-keygen -t ed25519 -C "$gh_email" -f "$HOME/.ssh/id_ed25519" -N ""
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  echo "Add this SSH key to GitHub:"
  cat ~/.ssh/id_ed25519.pub
  echo "https://github.com/settings/keys"
fi

echo "Setting up credentials..."
gh auth login
eval $(op signin --account acme.1password.com)

echo "Setup complete"
