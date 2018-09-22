#!/usr/bin/env bash

# To show all Bartender Bar items, remove Application menu when needed
defaults write com.surteesstudios.Bartender  bartenderAutoExtendsMenuBar -bool false

# Bartender items autohides
defaults write com.surteesstudios.Bartender  bartenderBarDoesntAutohide -bool false

# Bartender has launched before
defaults write com.surteesstudios.Bartender SUHasLaunchedBefore -bool true

# Check for Updates Automatically
defaults write com.surteesstudios.Bartender SUAutomaticallyUpdate -bool true

# When on battery, decrease update checking
defaults write com.surteesstudios.Bartender ReduceUpdateCheckFrequencyWhenOnBattery -bool true

# Bartender menu bar icon visible
defaults write com.surteesstudios.Bartender showMenuBarIcon -bool true

# Bartender menu bar icon:
# Waistcoat, Bartender, Bowtie, Glasses, Star, Box
defaults write com.surteesstudios.Bartender statusBarImageNamed -string "More"

# TODO: Configure Menu appearance