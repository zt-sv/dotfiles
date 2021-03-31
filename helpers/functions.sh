#!/usr/bin/env bash

# Check commands
command_exists () {
    type "$1" &> /dev/null ;
}

# Dialog
ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -t 1 -n 10000 discard
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

check_status() {
    if [ "$1" -eq 0 ]; then
        echo "${grn}${toend}[OK]"
    else
        echo "${red}${toend}[fail]"
    fi
    echo "${end}"
    echo
}

#based on https://stackoverflow.com/a/54261882
function prompt_for_multiselect {
    printf "\nUsage: '%sspace%s' to select, '%senter%s' to confirm, arrows for navigation. Press '%sa%s' to select all. Press '%sd%s' to deselect all. \n" "${yel}" "${end}" "${yel}" "${end}" "${yel}" "${end}" "${yel}" "${end}"
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x61' ]]; then echo all; fi;
      if [[ $key = $'\x64' ]]; then echo deall; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi
    }
    deselect_all()     {
      local arr_name=$1
      local arr=()
      local opts_name=$2
      eval "local opts_arr=(\"\${${opts_name}[@]}\")"

      for ((i=0; i<${#opts_arr[@]}; i++)); do
        arr[$i]=
      done

      eval $arr_name='("${arr[@]}")'
    }
    select_all()       {
      local arr_name=$1
      local arr=()
      local opts_name=$2
      eval "local opts_arr=(\"\${${opts_name}[@]}\")"

      for ((i=0; i<${#opts_arr[@]}; i++)); do
        arr[$i]=true
      done

      eval $arr_name='("${arr[@]}")'
    }
    toggle_option()    {
      local arr_name=$1
      eval "local arr=(\"\${${arr_name}[@]}\")"
      local option=$2
      if [[ ${arr[option]} == true ]]; then
        arr[option]=
      else
        arr[option]=true
      fi
      eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options=("${!2}")
    local defaults
    local selected=()

    if [[ -z $3 ]]; then
      defaults=()
    else
      IFS=';' read -r -a defaults <<< "$3"
    fi

    for ((i=0; i<${#options[@]}; i++)); do
      selected+=("${defaults[i]}")
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[idx]} == true ]]; then
              prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
            all)    select_all selected options;;
            deall)  deselect_all selected options;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    local res=()
    for index in "${!selected[@]}"
    do
      if [[ ${selected[index]} == true ]]; then
        res+=(${options[index]})
      fi
    done

    eval $retval='("${res[@]}")'
}
