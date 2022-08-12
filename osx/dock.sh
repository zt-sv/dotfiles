#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# No bouncing icons
defaults write com.apple.dock no-bouncing -bool true

# Dock to the right
defaults write com.apple.dock orientation -string "right"

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

if [ ! -z "$DOCK_ITEMS" ]; then
    printf "Setup Dock items..."
    # clear items
    defaults write com.apple.dock persistent-apps -array

    for dockItem in "${DOCK_ITEMS[@]}"; do
      printf "\n + Add Dock item %s%s%s" "${yel}" "${dockItem}" "${end}"
      defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${dockItem}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    done

    printf "\n\n"
fi

killall Dock
