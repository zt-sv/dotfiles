#############################################
#                                           #
#                   CASK                    #
#          http://caskroom.io/              #
#                                           #
#############################################

printf "\n%s================= Cask ================%s\n" "${cyn}" "${end}"

cask_installed () {
    ! brew cask info "$1"|grep "Not installed" > /dev/null ;
}

install_cask() {
    if ! cask_installed "$1"; then
        printf "\nInstalling homebrew cask %s...\n" "$1"
        brew cask install "$1"
        check_status $?
    else
        printf "\nSkipping homebrew cask %s, already installed.\n" "$1"
    fi
}

# Install Homebrew Cask itself

brew tap caskroom/cask
brew tap caskroom/versions

# if ! command_exists brew cask; then
    printf "\nInstalling Homebrew Cask...\n"
    brew install caskroom/cask/brew-cask
    check_status $?
# fi

printf "\nInstalling cask packages...\n"

# Define packages to install
cask_pkgs=(
    webstorm
    sequel-pro
    psequel
    dropbox
    firefox
    virtualbox
    vagrant
    vagrant-manager
    iterm2
    skype
    nylas-n1
    sublime-text3
    vlc
    google-chrome
    lastfm
    sourcetree
    utorrent
    xld

    # Quicklook plugins https://github.com/sindresorhus/quick-look-plugins
    qlcolorcode
    qlstephen
    qlmarkdown
    quicklook-json
    qlprettypatch
    quicklook-csv
    betterzipql
    qlimagesize
    webpquicklook
    suspicious-package
)

# Install all cask
for cask_pkg in "${cask_pkgs[@]}"
do
    install_cask $cask_pkg
done

printf "\n%s========= Complete, clean up ==========%s\n" "${cyn}" "${end}"
brew cask cleanup
check_status $?
