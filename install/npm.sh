#!/usr/bin/env bash

install_package() {
    if ! command_exists "$1"; then
        printf "\nInstalling npm package %s...\n" "${yel}$1${end}"
        sudo npm install --global --quiet "$1"
        check_status $?
    else
        printf "\nSkipping npm package %s, already installed.\n" "${yel}$1${end}"
    fi
}

printf "\nInstalling global npm packages...\n"

# Define packages to install
packages=(
    n
)

# Install all packages
for package in "${packages[@]}"
do
    install_package $package
done