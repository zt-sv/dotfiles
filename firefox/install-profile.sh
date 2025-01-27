#!/usr/bin/env bash

if test -d "${HOME}/Library/Application Support/Firefox"; then
  FF_DIR="${HOME}/Library/Application Support/Firefox"
elif test -d "${HOME}/Library/ApplicationSupport/Firefox"; then
  FF_DIR="${HOME}/Library/ApplicationSupport/Firefox"
fi

if test -d "$FF_DIR" && test -f "${FF_DIR}/profiles.ini"; then
  PROFILES_INI_PATH="${FF_DIR}/profiles.ini"
  PROFILES_COUNT=$(grep -c '^\[Profile' "$PROFILES_INI_PATH")
  PROFILES_NAMES=$(grep '^\[Profile' "$PROFILES_INI_PATH")
  PROFILES_NAMES=(${PROFILES_NAMES// / })

  install_config_for_profile() {
    local profile_name=$2
    local profile_name_esc=${profile_name//\[/\\[}
    profile_name_esc=${profile_name_esc//\]/\\]}

    # https://stackoverflow.com/a/40778047
    local profile_sub_path=$(gsed -nr "/^${profile_name_esc}/ { :l /^Path[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" "$PROFILES_INI_PATH")
    local profile_full_path="${FF_DIR}/${profile_sub_path}"

    printf "\nInstall configuration %s for profile %s, located %s \n" "${yel}overrides-prefs.js${end}" "${yel}${profile_name}${end}" "${yel}${profile_sub_path}${end}"

    curl -fsSL https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh --output "${profile_full_path}/prefsCleaner.sh"
    chmod +x "${profile_full_path}/prefsCleaner.sh"
    /usr/local/bin/bash -c "\"${profile_full_path}/prefsCleaner.sh\" -s" >> /dev/null
    /usr/local/bin/bash -c "$DOTFILES_DIR/firefox/updater.sh -p \"${profile_full_path}\" -o \"$DOTFILES_DIR/firefox/overrides-prefs.js\" -s" >> /dev/null
  }

  curl -fsSL https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh --output "$DOTFILES_DIR/firefox/updater.sh"
  chmod +x "$DOTFILES_DIR/firefox/updater.sh"
  osascript -e 'tell application "Firefox" to quit'
  printf "\nInstall configuration %s. Choose profile\n" "${yel}${pref}${end}"
  SELECTED_PROFILES=()
  prompt_for_multiselect SELECTED_PROFILES PROFILES_NAMES[@]

  for p_name in "${SELECTED_PROFILES[@]}"; do
    install_config_for_profile "${p_name}"
  done
fi
