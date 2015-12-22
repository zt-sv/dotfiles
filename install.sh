#!/bin/sh

# Die on failures
# set -e

# Echo all commands
# set -x

# Define colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

# To end caret
toend=$(tput hpa $(tput cols))$(tput cub 6)

# Dotfiles dir
DOTFILES_DIR="$( pwd )"

#############################################
#                                           #
#                  HELPERS                  #
#                                           #
#############################################

# Check commands
command_exists () {
    type "$1" &> /dev/null ;
}

# Dialog
ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -t 1 -n 10000 discard
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

check_status() {
    if [ "$1" -eq 0 ]; then
        echo "${grn}${toend}[OK]"
    else
        echo "${red}${toend}[fail]"
    fi
    echo "${end}"
    echo
}


#############################################
#                                           #
#             Package managers              #
#                                           #
#############################################

# Insall hombrew and packages
. "$DOTFILES_DIR/install/homebrew.sh"

# Install cask and packages
. "$DOTFILES_DIR/install/cask.sh"

# Install NPM packages
. "$DOTFILES_DIR/install/npm.sh"

#############################################
#                                           #
#                  Configs                  #
#                                           #
#############################################

# Sublime
printf "\n%s======== Sublime Configuration ========%s\n" "${cyn}" "${end}"
printf "Add Sublime Text CLI...\n"
sudo ln -sf "~/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime
check_status $?

printf "Install Sublime Predawn theme";
git clone https://github.com/jamiewilson/predawn.git ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/Predawn

# Git
printf "\n%s========== Git Configuration ==========%s\n" "${cyn}" "${end}"

printf "\nSetup .gitconfig...\n"
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
check_status $?

printf "\nSetup .gitignore_global...\n"
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
check_status $?

read -t 1 -n 10000 discard
read -p "Enter your name: " name
git config --global user.name "$name"

read -t 1 -n 10000 discard
read -p "Enter your email: " name
git config --global user.email "$email"

read -t 1 -n 10000 discard
read -p "Enter your GitHub username: " github
git config --global github.user "$github"

if ask "Do you want generate ssh key?" Y; then
    ssh-keygen -t rsa -C "$email"
    check_status $?
    printf "Copy generated key to your github profile and test connection with command \n%sssh -T git@github.com%s\n" "${red}" "${end}"
fi

# Bash profile
printf "\n%s====== Bash profile Configuration =====%s\n" "${cyn}" "${end}"
cd ~/
printf "\nSetup .bash_profile...\n"
ln -sfv "$DOTFILES_DIR/.bash_profile" ~
check_status $?

# Set up hostname
read -t 1 -n 10000 discard
read -p "Enter hostname: " hostname
sudo scutil --set ComputerName "$hostname"
sudo scutil --set HostName "$hostname"
sudo scutil --set LocalHostName "$hostname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
check_status $?

# MacOS set up
printf "\n%s========= MacOS Configuration =========%s\n" "${cyn}" "${end}"
printf "Setup masos...\n"
. "$DOTFILES_DIR/osx/osxhack.sh"
check_status $?
printf "Setup dock...\n"
. "$DOTFILES_DIR/osx/dock.sh"
check_status $?

# Mac backups
ln -sfv "$DOTFILES_DIR/.mackup.cfg" ~



#############################################
#                                           #
#                 COMPLETE                  #
#                                           #
#############################################

printf "\n%sInstall complete. Please, restart your computer%s\n" "${red}" "${end}"

if ask "Do you want restart computer now?" Y; then
    sudo shutdown -r now
fi
