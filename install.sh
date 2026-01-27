#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
section() { echo -e "\n${BLUE}==>${NC} $1"; }

# ==============================================================================
# Helper Functions
# ==============================================================================

# Check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check if a brew formula is installed
brew_formula_installed() {
    brew list --formula 2>/dev/null | grep -q "^$1\$"
}

# Check if a brew cask is installed
brew_cask_installed() {
    brew list --cask 2>/dev/null | grep -q "^$1\$"
}

# Check if an app exists in /Applications
app_exists() {
    local app_name="$1"
    [ -d "/Applications/${app_name}.app" ]
}

# Install brew formula if not installed
install_formula() {
    local name="$1"
    if brew_formula_installed "$name"; then
        info "Already installed: $name"
    else
        info "Installing: $name"
        brew install "$name"
    fi
}

# Install brew cask if not installed
install_cask() {
    local name="$1"
    local app_name="${2:-}"

    if brew_cask_installed "$name"; then
        info "Already installed: $name (cask)"
    elif [ -n "$app_name" ] && app_exists "$app_name"; then
        info "Already installed: $name (manual)"
    else
        info "Installing: $name (cask)"
        brew install --cask "$name"
    fi
}

# Backup and link function
link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            info "Already linked: $dest"
            return
        fi
        warn "Backing up existing: $dest -> ${dest}.backup"
        mv "$dest" "${dest}.backup"
    fi

    ln -s "$src" "$dest"
    info "Linked: $dest"
}

# ==============================================================================
# Install Homebrew
# ==============================================================================

section "Checking Homebrew"

if command_exists brew; then
    info "Homebrew already installed"
else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ==============================================================================
# Install Dependencies
# ==============================================================================

section "Installing dependencies"

# Terminal
install_cask "ghostty" "Ghostty"
install_formula "zellij"

# Font
install_cask "font-hack-nerd-font"

# Development tools (used in zellij layout)
install_formula "yazi"
install_formula "lazygit"
install_cask "claude-code" "Claude"

# ==============================================================================
# Install Oh My Zsh
# ==============================================================================

section "Checking Oh My Zsh"

if [ -d "$HOME/.oh-my-zsh" ]; then
    info "Oh My Zsh already installed"
else
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ==============================================================================
# Install Powerlevel10k
# ==============================================================================

section "Checking Powerlevel10k"

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [ -d "$P10K_DIR" ]; then
    info "Powerlevel10k already installed"
else
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ==============================================================================
# Link Dotfiles
# ==============================================================================

section "Linking dotfiles"

# Shell
link_file "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"

# Ghostty
mkdir -p "$HOME/.config/ghostty"
link_file "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# Zellij
mkdir -p "$HOME/.config/zellij/layouts"
link_file "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
link_file "$DOTFILES_DIR/zellij/layouts/dev.kdl" "$HOME/.config/zellij/layouts/dev.kdl"

# Yazi
mkdir -p "$HOME/.config/yazi"
link_file "$DOTFILES_DIR/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# ==============================================================================
# Done
# ==============================================================================

section "Installation complete!"
echo ""
echo "Please restart your terminal or run: source ~/.zshrc"
echo "Then run 'p10k configure' to setup Powerlevel10k if needed."
