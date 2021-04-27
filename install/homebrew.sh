#!/usr/bin/env bash

install_bottle() {
    if ! command_exists "$1"; then
        printf "Installing bottle %s...\n" "${yel}$1${end}"
        brew install "$1"
        check_status $?
    else
        printf "Skipping bottle %s, already installed.\n" "${yel}$1${end}"
    fi
}

if ! command_exists brew; then
    printf "\nInstalling Homebrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    check_status $?
fi

printf "\nHomebrew %s installed...\n" "$(brew -v)"

BREW_PREFIX=$(brew --prefix)

if [ "$(id -u)" -ne "$(stat -f "%u" /usr/local/Cellar)" ]; then
    printf "\nFix /usr/local/Cellar owner...\n"
    sudo chown -R "$USER" /usr/local/Cellar
fi

printf "\nUpdate homebrew bottles...\n"
brew update
brew upgrade
check_status $?

printf "\nInstalling homebrew bottles...\n"

# Define bottles to install
bottles=(
  bash
  bash-completion2
  coreutils
  csvdiff
  docker
  dockutil
  git
  gnu-sed
  go
  helm
  htop
  jq
  kubernetes-cli
  kustomize
  libyaml
  mackup
  minio-mc
  nmap
  node
  protobuf
  pyenv
  python@3.8
  s3cmd
  svgcleaner
  telnet
  tor
  watch
  wget
)

selected_bottles=()
prompt_for_multiselect selected_bottles bottles[@]

# Install all bottles
for bottle in "${selected_bottles[@]}"
do
    install_bottle $bottle

    case "$bottle" in
      "tor")
        mkdir -p ~/Library/LaunchAgents/
        printf "\nConfigure TOR proxy...\n"
        ln -sfv "$DOTFILES_DIR/torrc" /usr/local/etc/tor/torrc
        printf "\nStart TOR at login...\n"
        ln -sfv /usr/local/opt/tor/*.plist ~/Library/LaunchAgents/
        ;;

      "bash")
        printf "\nSwitch to using brew-installed bash as default shell\n"
        if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
          echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
          chsh -s "${BREW_PREFIX}/bin/bash";
        fi;
        ;;

      *)
        ;;
    esac

done

printf "\n%s========= Complete, clean up ==========%s\n" "${cyn}" "${end}"
brew cleanup
check_status $?
