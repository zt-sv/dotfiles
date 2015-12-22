#############################################
#                                           #
#                 Homebrew                  #
#              http://brew.sh/              #
#                                           #
#############################################

printf "\n%s================ Brew =================%s\n" "${cyn}" "${end}"

install_bottle() {
    if ! command_exists "$1"; then
        printf "Installing bottle %s...\n" "$1"
        brew install "$1"
        check_status $?
    else
        printf "Skipping bottle %s, already installed.\n" "$1"
    fi
}

if ! command_exists brew; then
    printf "\nInstalling Homebrew...\n"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    check_status $?
fi

brew -v

printf "\nUpdate homebrew bottles...\n"
sudo chown -R "$USER" /usr/local/Cellar
brew tap homebrew/versions
brew tap homebrew/dupes
brew tap homebrew/completions
brew update
brew upgrade
check_status $?

printf "\nInstalling homebrew bottles...\n"

# Define bottles to install
bottles=(
    mackup
    git
    bash-completion
    node
    dockutil
    midnight-commander
    mongodb
    redis
)

# Install all bottles
for bottle in "${bottles[@]}"
do
    install_bottle $bottle
done

printf "\n%s========= Complete, clean up ==========%s\n" "${cyn}" "${end}"
brew cleanup
check_status $?