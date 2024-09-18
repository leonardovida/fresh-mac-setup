#!/bin/bash
# Initial MacBook setup: installation, configuration, and restoration of backed-up settings using Mackup

set -euo pipefail

LOG_FILE="./setup.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

install_homebrew() {
    log "Starting Homebrew installation..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    log "Homebrew installation completed."
}

update_brew() {
    log "Updating Homebrew..."
    brew update && brew upgrade
    brew doctor
    brew tap homebrew/cask-versions
    log "Homebrew updated and tapped."
}

install_packages() {
    log "Installing brew formulae..."
    while read -r formula; do
        brew install "$formula" || log "Failed to install $formula"
    done < brew_packages.txt

    log "Installing brew casks..."
    while read -r cask; do
        brew install --cask "$cask" || log "Failed to install $cask"
    done < brew_casks.txt

    brew cleanup
    log "Package installation complete."
}

configure_git() {
    log "Configuring Git..."
    git config --global user.name "Leonardo Vida"
    git config --global user.email "lleonardovida@gmail.com"
    log "Git configured."
}

setup_zsh() {
    log "Setting up Zsh and Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions"
    log "Zsh setup complete."
}

configure_finder() {
    log "Configuring Finder settings..."
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
    defaults write com.apple.finder AppleShowAllFiles -bool TRUE
    killall Finder
    log "Finder configured."
}

setup_mackup() {
    log "Mackup configuration prompted."
    read -rp "--> Do you want to create a config file for Mackup? (y/n): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        log "Creating Mackup config file..."
        cat <<EOF >"$HOME/.mackup.cfg"
[storage]
engine = icloud
EOF
        log "Mackup config file created."
    else
        log "Skipping Mackup config file creation."
    fi

    read -rp "--> Do you want to restore your config files and settings using Mackup? (y/n): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        log "Restoring settings via Mackup..."
        mackup restore || log "Mackup restore failed."
        log "Mackup restoration complete."
    else
        log "Skipping Mackup restoration."
    fi
}

main() {
    log "Setup script started."

    read -rp "--> Do you want to install Homebrew? (y/n): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        install_homebrew
        update_brew
    else
        log "Homebrew installation skipped."
        exit 0
    fi

    install_packages
    configure_git
    setup_zsh
    configure_finder
    setup_mackup

    log "--> JOB'S DONE !!"
}

main