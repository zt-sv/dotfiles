#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Disable guest user
defaults write com.apple.AppleFileServer guestAccess -bool false
defaults write SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false

# Require password immediately after the computer went into
# sleep or screen saver mode
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
