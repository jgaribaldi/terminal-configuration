#/bin/bash

brew install font-hack-nerd-font
brew install starship
brew install --cask ghostty
brew install neovim
brew install pipx
brew install markdownlint-cli2
pipx install debugpy
pipx ensurepath
git clone git@github.com:jgaribaldi/terminal-configuration.git .config/
git config --global core.editor nvim
