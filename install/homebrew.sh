#!/usr/bin/env bash

if ! command_exists brew; then
    printf "\nInstalling Homebrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_status $?
fi

printf "\nHomebrew %s installed...\n" "$(brew -v)"

BREW_PREFIX=$(brew --prefix)


# if ! test -f "/etc/paths.d/99-homebrew"; then
#     printf "\nAdd /usr/local/sbin path...\n"
#     sudo cat << EOF > "/etc/paths.d/99-homebrew"
# /usr/local/sbin
# EOF
# fi

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

if test -f "${BREWFILE}"; then
    printf "\nInstalling packages...\n"
    brew bundle --file "${BREWFILE}"
    check_status $?
else 
    printf "%sVariable BREWFILE isn't set. Skip installing packages.%s\n" "${yel}" "${end}"
fi

printf "\n%s========= Complete, clean up ==========%s\n" "${cyn}" "${end}"
brew cleanup
check_status $?
