#!/usr/bin/env bash

# Dotfiles dir
DOTFILES_DIR="$(pwd)"


. "$DOTFILES_DIR/helpers/colors.sh"
. "$DOTFILES_DIR/helpers/functions.sh"

printf "\n%sCheck XCode...%s" "${cyn}" "${end}"
if ! command_exists 'gcc'; then
    printf "\n%sThe XCode Command Line Tools must be installed first.%s\n" "${red}" "${end}"
    printf "\n%ssudo softwareupdate -i -a%s" "${red}" "${end}"
    printf "\n%sxcode-select --install%s" "${red}" "${end}"
    printf "\n%ssudo xcodebuild -license%s" "${red}" "${end}"
    exit 1
else
    printf "%s[OK]%s\n" "${grn}" "${end}"
fi

printf "\n%sLoad config...%s" "${cyn}" "${end}"
if test -f "$DOTFILES_DIR/config"; then
    . "$DOTFILES_DIR/config";
    printf "\nUsing %s%s%s as a configuration%s\n" "${cyn}" "$DOTFILES_DIR/config" "${end}"
else
    printf "%sConfiguration not found%s\n" "${yel}" "${end}"
fi

printf "\n%s#############################################%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#                 Homebrew                  #%s" "${cyn}" "${end}"
printf "\n%s#              http://brew.sh/              #%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#############################################%s\n" "${cyn}" "${end}"
. "$DOTFILES_DIR/install/homebrew.sh"

printf "\n%s#################################################%s" "${cyn}" "${end}"
printf "\n%s#                                               #%s" "${cyn}" "${end}"
printf "\n%s#            setup macOS Defaults               #%s" "${cyn}" "${end}"
printf "\n%s# https://github.com/kevinSuttle/macOS-Defaults #%s" "${cyn}" "${end}"
printf "\n%s#                                               #%s" "${cyn}" "${end}"
printf "\n%s#################################################%s\n" "${cyn}" "${end}"

osascript -e 'tell application "System Preferences" to quit'

printf "Setup general settings...\n"
. "$DOTFILES_DIR/osx/general.sh"

printf "Setup security settings...\n"
. "$DOTFILES_DIR/osx/security.sh"

printf "Setup energy savings settings...\n"
. "$DOTFILES_DIR/osx/energy-saving.sh"

printf "Setup time machine settings...\n"
. "$DOTFILES_DIR/osx/time-machine.sh"

printf "Setup keyboard settings...\n"
. "$DOTFILES_DIR/osx/keyboard.sh"

printf "Setup trackpad settings...\n"
. "$DOTFILES_DIR/osx/trackpad.sh"

printf "Setup screen settings...\n"
. "$DOTFILES_DIR/osx/screen.sh"

printf "Setup dashboard settings...\n"
. "$DOTFILES_DIR/osx/dashboard.sh"

printf "Setup mision control settings...\n"
. "$DOTFILES_DIR/osx/mission-control.sh"

printf "Setup finder settings...\n"
. "$DOTFILES_DIR/osx/finder.sh"

printf "Setup dock settings...\n"
. "$DOTFILES_DIR/osx/dock.sh"

printf "Setup apps settings...\n"
. "$DOTFILES_DIR/osx/apps.sh"


printf "\n%s#############################################%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#                  Mackup                   #%s" "${cyn}" "${end}"
printf "\n%s#       https://github.com/lra/mackup       #%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#############################################%s\n" "${cyn}" "${end}"
ln -sfv "$DOTFILES_DIR/.mackup.cfg" ~
ln -sfv "$DOTFILES_DIR/.mackup" ~

if ask "Do you want to restore Mackup backups now?" Y; then
    mackup restore
fi

printf "\n%sConfigure Firefox profile...%s\n" "${cyn}" "${end}"
. "$DOTFILES_DIR/firefox/install-profile.sh"

printf "\n%sInstall complete. Please, restart your computer%s\n" "${red}" "${end}"

if ask "Do you want restart computer now?" Y; then
    sudo shutdown -r now
fi
