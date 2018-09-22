#!/usr/bin/env bash

# Install config
mkdir -p $HOME/.config/iterm2/
cp com.googlecode.iterm2.plist $HOME/.config/iterm2/

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
# Hide Pane titles
defaults write com.googlecode.iterm2.plist ShowPaneTitles -bool false
# Set Dark mode
defaults write com.googlecode.iterm2.plist TabStyle -int 1
# Hide Tab bar in fullscreen mode
defaults write com.googlecode.iterm2.plist ShowFullScreenTabBar -bool false
# Hide window number
defaults write com.googlecode.iterm2.plist WindowNumber -bool false
# Hide job name
defaults write com.googlecode.iterm2.plist JobName -bool false
# Hide tab close button
defaults write com.googlecode.iterm2.plist HideTabCloseButton -bool true
# Hide Activity indicator
defaults write com.googlecode.iterm2.plist HideActivityIndicator -bool true
# Don't flash tab bar when switching tabs in fullscreen mode
defaults write com.googlecode.iterm2.plist FlashTabBarInFullscreen -bool false