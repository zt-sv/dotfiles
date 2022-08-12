#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

printf "Set computer name...\n"
if [ -z "$COMPUTERNAME" ]; then
	read -t 1 -n 10000 discard
	read -p "Enter computer name: " COMPUTERNAME
fi

printf " + Computer name is %s%s%s\n" "${yel}" "$COMPUTERNAME" "${end}"
sudo scutil --set ComputerName "$COMPUTERNAME"
sudo scutil --set HostName "$COMPUTERNAME"
sudo scutil --set LocalHostName "$COMPUTERNAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTERNAME"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set Sidebar icon size to small.
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Show scrollbars WhenScrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en-RU", "ru-RU"
defaults write NSGlobalDomain AppleLocale -string "en_RU@currency=RUB"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
# sudo systemsetup -settimezone "Europe/Moscow" > /dev/null