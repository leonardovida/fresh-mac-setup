#!/bin/sh
# Initial MacBook installation, configuration and restoration of backed up settings (done with Mackup)

# Exit immediately if a command exits with a non-zero status
set -e

# SSH
echo -n "--> Do you want to generate a SSH key? (y/n)"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "--> Generating SSH key .."
    ssh-keygen
else
    echo "--> Skipping key generation .."
fi

# Install Homebrew
echo "--> Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/leonardovida/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

# Update & fix Homebrew
brew update && brew upgrade
brew doctor
brew tap homebrew/cask-versions

# Tap additional repos
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"
tap "homebrew/core"
tap "homebrew/services"

# System
brew "mas"
brew "curl"
brew "wget"
brew "git"
brew "vim"
brew "openssl"
brew "coreutils"
brew "moreutils"
brew "findutils"
brew "binutils"
brew "rename"
brew "gnu-sed"
brew "gnu-tar"
brew "gawk"
brew "gnutls"
brew "gnu-indent"
brew "gnu-getopt"
brew "tree"
brew "htop"
brew "pidof"
brew "pstree"
brew "grep"
brew "openssh"
brew "rsync"
brew "ssh-copy-id"
brew "screen"
brew "gmp"
brew "nmap"
brew "socat"
brew "rlwrap"
brew "dnstracer"

# Install apps from the Mac App Store
mas "Slack", id: 803453959

# MacOS livable
brew install openssl readline sqlite3 xz zlib
brew install git zsh authy caffeine mackup whatsapp spotify discord starship transmission vlc
brew install --cask 1password/tap/1password-cli
brew install --cask 1password
brew install --cask rectangle
brew install --cask raycast
brew install docker
brew install git-lfs
brew install --cask nordvpn
brew install --cask docker
brew install docker-compose
brew install --cask warp
brew install --cask todoist
brew install pipx
brew install --cask dash
brew install --cask betterdisplay
# Development apps
brew install terraform pyenv scala java apache-spark vscodium pyenv-virtualenv gh railway
brew install pre-commit terraform-docs tflint tfsec checkov terrascan infracost tfupdate minamijoyo/hcledit/hcledit jq
brew install zsh-syntax-highlighting
brew install --cask hyper
# Additional apps
brew install zurawiki/brews/gptcommit
brew install --cask notion
brew install --cask tableplus
brew install microsoft-edge
brew install --cask kaleidoscope
brew install --cask krisp
brew install --cask visual-studio-code

echo "--> Creating config file for Mackup .."
cat <<EOF >~/.mackup.cfg
[storage]
engine = icloud
EOF

# Git configure
git config --global user.name "Leonardo Vida"
git config --global user.email "leonardo.vida@brenntag.com"

# Install python versions
pyenv install 3.10.9
pyenv install 3.11

# ZSH
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh in .zshrc

# Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# show directory path in Finder titlebar
echo "--> Showing directory pahh in Finder titlebar.." 
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES;killall Finder
defaults write com.apple.Finder AppleShowAllFiles true;killall Finder

### Mackup
echo -n "--> Do you want to restore your config files and settings using Mackup? (y/n)"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "--> Restoring settings via Mackup (iCloud) .." 
    mackup restore
else
    echo "--> Skipping Mackup restore .."
fi

echo "--> JOB's DONE !!"