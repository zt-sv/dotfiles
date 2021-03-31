#!/usr/bin/env bash

# Dotfiles dir
DOTFILES_DIR="$(pwd)"

. "$DOTFILES_DIR/helpers/colors.sh"
. "$DOTFILES_DIR/helpers/functions.sh"

printf "\n%sCheck XCode...%s\n" "${cyn}" "${end}"
if ! command_exists 'gcc'; then
    printf "\n%sThe XCode Command Line Tools must be installed first.%s\n" "${red}" "${end}"
    printf "\n%ssudo softwareupdate -i -a%s" "${red}" "${end}"
    printf "\n%sxcode-select --install%s" "${red}" "${end}"
    printf "\n%ssudo xcodebuild -license%s" "${red}" "${end}"
    exit 1
fi

printf "\n%s#############################################%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#                 Homebrew                  #%s" "${cyn}" "${end}"
printf "\n%s#              http://brew.sh/              #%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#############################################%s\n" "${cyn}" "${end}"
. "$DOTFILES_DIR/install/homebrew.sh"

printf "\n%s#############################################%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#                   CASK                    #%s" "${cyn}" "${end}"
printf "\n%s#      https://formulae.brew.sh/cask/       #%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#############################################%s\n" "${cyn}" "${end}"
. "$DOTFILES_DIR/install/cask.sh"

printf "\n%s#############################################%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#                    NPM                    #%s" "${cyn}" "${end}"
printf "\n%s#          https://www.npmjs.com/           #%s" "${cyn}" "${end}"
printf "\n%s#                                           #%s" "${cyn}" "${end}"
printf "\n%s#############################################%s\n" "${cyn}" "${end}"
. "$DOTFILES_DIR/install/npm.sh"

printf "\n%s#################################################%s" "${cyn}" "${end}"
printf "\n%s#                                               #%s" "${cyn}" "${end}"
printf "\n%s#                macOS-Defaults                 #%s" "${cyn}" "${end}"
printf "\n%s# https://github.com/kevinSuttle/macOS-Defaults #%s" "${cyn}" "${end}"
printf "\n%s#                                               #%s" "${cyn}" "${end}"
printf "\n%s#################################################%s\n" "${cyn}" "${end}"
printf "Setup macOS defaults...\n"
. "$DOTFILES_DIR/osx/macos.sh"
printf "Setup dock...\n"
. "$DOTFILES_DIR/osx/dock.sh"


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

printf "\n%sSetup hostname...%s\n" "${cyn}" "${end}"

read -t 1 -n 10000 discard
read -p "Enter hostname: " hostname
sudo scutil --set ComputerName "$hostname"
sudo scutil --set HostName "$hostname"
sudo scutil --set LocalHostName "$hostname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
check_status $?

printf "\nSetup .gitignore_global...\n"
ln -sfv "$DOTFILES_DIR/git/gitignore" ~/.gitignore
check_status $?

if ask "Do you want generate ssh key?" Y; then
    read -t 1 -n 10000 discard
    read -p "Enter your email: " email
    ssh-keygen -t rsa -b 4096 -C "$email"
    check_status $?
fi

printf "\n%sInstall complete. Please, restart your computer%s\n" "${red}" "${end}"

if ask "Do you want restart computer now?" Y; then
    sudo shutdown -r now
fi
