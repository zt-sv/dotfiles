#!/usr/bin/env bash

if ! command_exists brew; then
    printf "\nInstalling Homebrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_status $?
fi

printf "\nHomebrew %s installed...\n" "$(brew -v)"

BREW_PREFIX=$(brew --prefix)

if [ "$(id -u)" -ne "$(stat -f "%u" /usr/local/Cellar)" ]; then
    printf "\nFix /usr/local/Cellar owner...\n"
    sudo chown -R "$USER" /usr/local/Cellar
fi

printf "\nUpdate homebrew bottles...\n"
brew analytics off
check_status $?
brew update
check_status $?

brew tap "homebrew/bundle"

if test -f "${HOMEBREW_BUNDLE_FILE}"; then
    printf "\nInstalling packages...\n"
    brew bundle --file "${HOMEBREW_BUNDLE_FILE}"
    check_status $?
else 
    printf "%sVariable HOMEBREW_BUNDLE_FILE isn't set. Skip installing packages.%s\n" "${yel}" "${end}"
fi

printf "\n%s========= Complete, clean up ==========%s\n" "${cyn}" "${end}"
brew cleanup
check_status $?
