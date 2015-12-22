#############################################
#                                           #
#                    NPM                    #
#          https://www.npmjs.com/           #
#                                           #
#############################################

printf "\n%s================ NPM ==================%s\n" "${cyn}" "${end}"

install_package() {
    if ! command_exists "$1"; then
        printf "\nInstalling npm package %s...\n" "$1"
        sudo npm install -g "$1"
        check_status $?
    else
        printf "\nSkipping npm package %s, already installed.\n" "$1"
    fi
}

printf "\nInstalling global npm packages...\n"

# Define packages to install
packages=(
    grunt
    grunt-cli
    n
)

# Install all packages
for package in "${packages[@]}"
do
    install_package $package
done