__set_ps1() {
    # Color picker - https://robotmoon.com/bash-prompt-generator/
    local default_user_background_color=27
    local default_user_text_color=195

    local root_user_background_color=214
    local root_user_text_color=195

    local dir_background_color=45
    local dir_text_color=17

    local venv_background_color=195
    local venv_text_color=17

    local git_background_color=195
    local git_text_color=17

    local git_changes_background_color=214
    local git_changes_text_color=17

    prompt_git() {
        local bgcolor="${git_background_color}"
        local textcolor="${git_text_color}"
        local s='';
        local branchName='';
        local res='';

        # Check if the current directory is in a Git repository.
        if ! $(git rev-parse --is-inside-work-tree &>/dev/null); then
            res+=`render_separator --prev_bg_color $dir_background_color`
            echo -e "${res}"
            return;
        fi;

        # Check for what branch we’re on.
        # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
        # tracking remote branch or tag. Otherwise, get the
        # short SHA for the latest commit, or give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git describe --all --exact-match HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";

        # Check for uncommitted changes in the index.
        if ! $(git diff --quiet --ignore-submodules --cached); then
            # s+='+';
            s='✱';
        fi;
        # Check for unstaged changes.
        if ! $(git diff-files --quiet --ignore-submodules --); then
            # s+='!';
            s='✱';
        fi;
        # Check for untracked files.
        if [ -n "$(git ls-files --others --exclude-standard)" ]; then
            # s+='?';
            s='✱';
        fi;
        # Check for stashed files.
        if $(git rev-parse --verify refs/stash &>/dev/null); then
            # s+='$';
            s='✱';
        fi;

        if [ -n "${s}" ]; then
            bgcolor="${git_changes_background_color}";
            textcolor="${git_changes_text_color}";
        else
            s="✔"
        fi;


        res+=`render_separator --prev_bg_color $dir_background_color --next_bg_color $bgcolor`
        res+=`render_container --background $bgcolor --textcolor $textcolor --text "  $branchName [$s] "`
        res+=`render_separator --prev_bg_color $bgcolor`

        echo -e "${res}"
    }

    prompt_app() {
      local user_text_color=$1
      local res='';
      local apps=();

      if [[ -n "${VIRTUAL_ENV-}" ]]; then
        apps+=("$(render_container --background $venv_background_color --textcolor $venv_text_color --text ' [ v$(python --version)] ')");
      fi;
      if [[ -n "${NVM_BIN-}" ]]; then
        apps+=("$(render_container --background $venv_background_color --textcolor $venv_text_color --text ' [ $(node --version)] ')");
      fi;

      for index in "${!apps[@]}"
      do
        [[ $index -ne 0 ]] && res+=`render_container --background $venv_background_color --textcolor $venv_text_color --text '&&'`;
        res+="${apps[index]}"
      done

      if [[ -n "${res}" ]]; then
        res="`render_separator --prev_bg_color $user_bg_color --next_bg_color $venv_background_color`${res}"
        res+=`render_separator --prev_bg_color $venv_background_color --next_bg_color $dir_background_color`
      else
        res+=`render_separator --prev_bg_color $user_bg_color --next_bg_color $dir_background_color`
      fi;
      echo -e "${res}"
    }

    render_container() {
        local background textcolor is_bold text res 

        while [ "$#" -gt 0 ]; do
            case "$1" in
              --background)
                background="$2"
                shift 2
                ;;
              --is_bold)
                is_bold="$2"
                shift 2
                ;;
              --textcolor)
                textcolor="$2"
                shift 2
                ;;
              --text)
                text="$2"
                shift 2
                ;;
              *)
                echo "${red}Unknown option: $1${end}"
                return 1
                ;;
            esac
        done

        res="${text}"
        [[ ! -z "$textcolor" ]] && res="$(tput setaf $textcolor)${res}"
        [[ ! -z "$background" ]] && res="$(tput setab $background)${res}"
        [[ ! -z "$is_bold" ]] && res="$(tput bold)${res}"
        res+="\[$(tput sgr0)\]"

        echo -e "$res"
    }

    render_separator() {
        local res='' sep='' prev_bg_color next_bg_color;

        while [ "$#" -gt 0 ]; do
            case "$1" in
              --prev_bg_color)
                prev_bg_color="$2"
                shift 2
                ;;
              --next_bg_color)
                next_bg_color="$2"
                shift 2
                ;;
              *)
                echo "${red}Unknown option: $1${end}"
                return 1
                ;;
            esac
        done

        if [[ -z "$next_bg_color" ]]; then
            res+=`render_container --textcolor $prev_bg_color --text $sep`;
        else
            res+=`render_container --background $next_bg_color --textcolor $prev_bg_color --text $sep`;
        fi;

        echo -e "$res"
    }

    local prompt_string user_bg_color;

    [[ "$USER" = "root" ]] && user_bg_color=$root_user_background_color || user_bg_color=$default_user_background_color
    [[ "$USER" = "root" ]] && user_text_color=$root_user_text_color || user_text_color=$default_user_text_color

    prompt_string+=`render_container --textcolor $user_bg_color --text '╭─'` # begin arrow to prompt
    prompt_string+=`render_container --background $user_bg_color --textcolor $user_text_color --text ' ⌘ \\u '`
    prompt_string+=`prompt_app $user_text_color`
    prompt_string+=`render_container --background $dir_background_color --textcolor $dir_text_color --text ' \\w '`
    prompt_string+=`prompt_git`
    prompt_string+=`render_container --textcolor $user_bg_color --text '\n╰▶  '` #`$`
    prompt_string+=`render_container --text '\\$ '` #`$`

    echo -e "$prompt_string"
}

function __prompt_command {
    export PS1=`__set_ps1`
}

export PROMPT_COMMAND=__prompt_command
export PS1=`__set_ps1`

# unset __set_ps1
