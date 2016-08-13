#############################################
#                                           #
#                Vagrant                    #
#       https://www.vagrantup.com/          #
#                                           #
#############################################

cask_installed () {
    ! brew cask info "$1"|grep "Not installed" > /dev/null ;
}

install_plugin() {
    printf "\nInstalling vagrant plugin %s...\n" "$1"
    vagrant plugin install "$1"
    check_status $?
}

# Install Vagrant itself

if ! cask_installed vagrant; then
    printf "\nInstalling Vagrant...\n"
    brew cask install vagrant --force
    check_status $?
else
    printf "\nSkipping Vagrant, already installed.\n"
fi

if ! cask_installed vagrant-manager; then
    printf "\nInstalling Vagrant Manager...\n"
    brew cask install vagrant-manager
    check_status $?
else
    printf "\nSkipping Vagrant Manager, already installed.\n"
fi

printf "\nInstalling vagrant plugins...\n"

# Define packages to install
vagrant_plugins=(
  vagrant-salt
  vagrant-hostmanager
)

# Install all cask
for plugin in "${vagrant_plugins[@]}"
do
    install_plugin plugin
done
