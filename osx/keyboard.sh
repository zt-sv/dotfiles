#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Disable automatic capitalization as it’s annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
sudo defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
sudo defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
sudo defaults write NSGlobalDomain KeyRepeat -int 1
sudo defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Stop iTunes from responding to the keyboard media keys
sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Use all F1, F2, etc. keys as standard function keys (requires restart)
defaults write -g com.apple.keyboard.fnState -bool true

# Show F1, F2, etc. keys on touchbar
defaults write com.apple.touchbar.agent PresentationModeGlobal -string "functionKeys"
pkill "Touch Bar agent"
killall "ControlStrip"

### Setup hotkeys

# Input Sources > Select the previous input source : Cmd + Space
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 60 "
  <dict>
    <key>enabled</key><true/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>32</integer>
        <integer>49</integer>
        <integer>1048576</integer>
      </array>
    </dict>
  </dict>
"

# Input Sources > Select next source in Input menu : Ctrl + Opt + Space
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 61 "
  <dict>
    <key>enabled</key><true/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>32</integer>
        <integer>49</integer>
        <integer>786432</integer>
      </array>
    </dict>
  </dict>
"

# Show Spotlight search field - Command, Shift, Space
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "
  <dict>
    <key>enabled</key><true/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>32</integer>
        <integer>49</integer>
        <integer>262144</integer>
      </array>
    </dict>
  </dict>
"