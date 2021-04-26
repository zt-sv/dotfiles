#!/usr/bin/env bash

cask_installed () {
    ! brew info "$1"|grep "Not installed" > /dev/null ;
}

install_cask() {
    if ! cask_installed "$1"; then
        printf "\nInstalling homebrew cask %s...\n" "${yel}$1${end}"
        brew install --cask "$1"
        check_status $?
    else
        printf "\nSkipping homebrew cask %s, already installed.\n" "${yel}$1${end}"
    fi
}

install_iterm2_util() {
  curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
}

# Install Homebrew Cask itself
brew tap homebrew/cask

printf "\nInstalling cask packages...\n"

# Define packages to install
cask_pkgs=(
    burp-suite
    drawio
    firefox
    google-chrome
    ilya-birman-typography-layout
    iterm2
    jetbrains-toolbox
    lastfm
    lens
    mailspring
    postman
    sublime-text
    telegram
    transmission
    tunnelblick
    virtualbox
)

selected_cask_pkgs=()
prompt_for_multiselect selected_cask_pkgs cask_pkgs[@]

# Install all cask
for cask_pkg in "${selected_cask_pkgs[@]}"
do
    install_cask $cask_pkg

    case "$cask_pkg" in
      "iterm2")
        if ask "Do you want to install iTerm2 utils now?" Y; then
            install_iterm2_util
        fi
        ;;
      *)
        ;;
    esac
done

printf "\n%s========= Complete, clean up ==========%s\n" "${cyn}" "${end}"
brew cleanup
check_status $?
