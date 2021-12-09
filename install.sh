brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono

ln -s "$HOME/.dotfiles/iTerm/Scripts/AutoLaunch" "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"

git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
