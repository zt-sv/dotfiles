#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true
