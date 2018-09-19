#!/usr/bin/env bash

# Install config
mkdir -p ~/.config/iterm2/
cp com.googlecode.iterm2.plist ~/.config/iterm2/

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
