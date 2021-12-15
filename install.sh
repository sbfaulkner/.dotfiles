#!/bin/bash
set -euo pipefail

brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono
brew install chruby shadowenv

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.dotfiles/iTerm/Preferences"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

ln -sf "$HOME/.dotfiles/iTerm/Scripts/AutoLaunch" "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"

git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$ZSH/custom}/themes/spaceship-prompt" --depth=1
ln -sf "${ZSH_CUSTOM:-$ZSH/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$ZSH/custom}/themes/spaceship.zsh-theme"

ln -sf "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"

git clone https://github.com/sbfaulkner/dev-plugin-zsh.git "$HOME/src/github.com/sbfaulkner/dev-plugin-zsh"
ln -sf "$HOME/src/github.com/sbfaulkner/dev-plugin-zsh" "${ZSH_CUSTOM:-$ZSH/custom}/plugins/dev"
git clone https://github.com/sbfaulkner/chgo-plugin-zsh.git "$HOME/src/github.com/sbfaulkner/chgo-plugin-zsh"
ln -sf "$HOME/src/github.com/sbfaulkner/chgo-plugin-zsh" "${ZSH_CUSTOM:-$ZSH/custom}/plugins/chgo"
