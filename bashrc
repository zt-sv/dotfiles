# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Add path to PATH if path exists and not in PATH
function _bashrc_add_path() {
    local NEWPATH=$1
    if [ -d "${NEWPATH}" ]; then
        if [ "${PATH/$NEWPATH}" == "$PATH" ]; then
            # Not set yet. Add the path
            PATH="$NEWPATH:$PATH"
        fi
    fi
}

# Source XGD envs first
[[ -r "${HOME}/.bashrc.d/xdg.bashrc" ]] && . "${HOME}/.bashrc.d/xdg.bashrc"

for file in ~/.bashrc.d/*.bashrc; do
    source "$file";
done

# Set Paths
_bashrc_add_path "${KREW_ROOT:-$HOME/.krew}"
_bashrc_add_path "$HOME/Library/Python/3.8/bin"
_bashrc_add_path "/usr/local/opt/gnu-tar/libexec/gnubin"
_bashrc_add_path "/usr/local/opt/mysql-client/bin"
_bashrc_add_path "/usr/local/opt/php@8.2/bin"
_bashrc_add_path "/usr/local/sbin"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Autocomplete
brew_etc="$(brew --prefix)/etc" && [[ -r "${brew_etc}/profile.d/bash_completion.sh" ]] && . "${brew_etc}/profile.d/bash_completion.sh"
