#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

# Git Autocomplete
# brew install git bash-completion
# ------------------------------------------------------------
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Change Prompt
# ------------------------------------------------------------
function __my_git_prompt {
    GIT_PS1=""
    if command -v git >/dev/null; then
        [ -f "/usr/local/etc/bash_completion.d/git-prompt.sh" ] && . "/usr/local/etc/bash_completion.d/git-prompt.sh"
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUNTRACKEDFILES=1
        GIT_PS1='$(__git_ps1 " (%s)")'
    fi
    echo "$GIT_PS1"
}

bash_prompt() {
  local NONE="\[\033[0m\]"    # unsets color to term's fg color

    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white

    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

    local UC=$W                 # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color

    PS1="________________________________________________________________________________\n$C| \w @ $EMY\h (\u)$EMW$(__my_git_prompt)$C\n| => ${NONE}"
    PS2="$EMY| => ${NONE} $"
}

bash_prompt
unset bash_prompt

#   Set Paths
#   ------------------------------------------------------------
export PATH=/usr/local/bin:$PATH

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
  # export CLICOLOR=1
  # export LSCOLORS=ExFxBxDxCxegedabagacad
export GREP_OPTIONS='--color=auto'

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ls='ls -FGlAhp'                       # Preferred 'ls' implementation

alias edit='subl'                        # edit:         Opens any file in sublime editor

alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display

cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview

# Watch command
watch () {
    while :;
    do
        date
        clear
        $2
        sleep $1
    done
}

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

alias brew_cask_update_upgrade='brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup && (brew cask list | xargs brew cask install --force)'
alias brew_cask_upgrage_casks='(brew cask list | xargs brew cask install --force) && brew cask cleanup'


#   -------------------------------
#   3. FILE AND FOLDER MANAGEMENT
#   -------------------------------

zipf () { zip -r "$1".zip "$1" ; } # zipf: To create a ZIP archive of a folder


#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}



#   ---------------------------
#   4. PROCESS MANAGEMENT
#   ---------------------------

# findPid: find out the pid of a specified process
# -----------------------------------------------------
# Note that the command name can be specified via a regex
# E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
# Without the 'sudo' it will only find processes of the current user
# -----------------------------------------------------
findPid () { lsof -t -c "$@" ; }

# memHogsTop, memHogsPs: Find memory hogs
# -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# cpuHogs: Find CPU hogs
# -----------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# topForever: Continual 'top' listing (every 10 seconds)
# -----------------------------------------------------
alias topForever='top -l 9999999 -s 10 -o cpu'

# ttop: Recommended 'top' invocation to minimize resources
# ------------------------------------------------------------
# Taken from this macosxhints article
# http://www.macosxhints.com/article.php?story=20060816123853639
# ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

# my_ps: List processes owned by my user:
# ------------------------------------------------------------
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


#   ---------------------------
#   5. NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

# ii: display useful host related informaton
# -------------------------------------------------------------------
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}


#   ---------------------------------------
#   6. WEB DEVELOPMENT
#   ---------------------------------------
alias editHosts='sudo subl /etc/hosts'  # editHosts: Edit /etc/hosts file
