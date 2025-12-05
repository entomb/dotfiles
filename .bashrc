# ~/.bashrc: executed by bash(1) for non-login shells.

# Detect if running in VS Code and set a variable
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ -n "$VSCODE_IPC_HOOK_CLI" ]]; then
    export IS_VS_CODE=true
else
    export IS_VS_CODE=false
fi

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

if [[ "$IS_VS_CODE" == "false" ]]; then
    # HISTORY
    shopt -s histappend
    HISTCONTROL=ignoreboth
    HISTSIZE=1000
    HISTFILESIZE=2000

    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='envy'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Change this to the name of the main development branch if
# you renamed it or if it was changed for some reason
# export BASH_IT_DEVELOPMENT_BRANCH='master'

# Your place for hosting Git repos. I use this for private repos.
# export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"
export EDITOR='vim'
export VISUAL='vim'
export SCM_CHECK=true

# BASHIT STUFF & OTHER CONFIGS
if [[ "$IS_VS_CODE" == "true" ]]; then
    # Settings for VS Code to keep it lightweight
    export SCM_CHECK=false
    # set git without pager
    export GIT_PAGER=cat
    alias git='git --no-pager'
else
    # Settings for regular terminals
    # SSH INIT - add your ssh keys here
    # ssh-add &>/dev/null
    # ssh-add ~/.ssh/id_ed25519 &>/dev/null
    export SCM_CHECK=true
fi

#export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"
#export GITSTATUS_NUM_THREADS=8
# export BASH_IT_RELOAD_LEGACY=1
#export SHORT_HOSTNAME=$(hostname -s)
#export SHORT_USER=${USER:0:8}
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt
#export BASH_IT_COMMAND_DURATION=true
#export COMMAND_DURATION_MIN_SECONDS=1
#export SHORT_TERM_LINE=true
# Load Bash It
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

source "$BASH_IT"/bash_it.sh

export AWS_EC2_METADATA_DISABLED=true
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

# API Keys and Tokens - set these in a local .bashrc.local or environment
# export NGROK_AUTHTOKEN="your_token_here"
# export DI_TOKEN="your_digitalocean_token_here"
# export GITHUB_TOKEN="your_github_token_here"

export ESLINT_CACHE=1

# some more ls aliases
alias reload="bash-it reload"
alias gg="git status"
alias gl="git lg"
alias gll="git log --graph --pretty=oneline --abbrev-commit"
alias clear="echo -ne \"\033c\""
alias json="fx"
alias l='ls -a1'
alias ll='ls -alo'
alias ls="ls --color=auto --group-directories-first --time-style=long-iso"
alias gco='git checkout'

# WSL/Windows specific
# export OLLAMA_URL="http://172.26.144.1:11434"
# alias ollama="ollama.exe"

# EXPORTS
export NVM_DIR="$HOME/.nvm"
# Only load nvm if in home directory to avoid issues with workspaces
if [ "$PWD" = "$HOME" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi


# Source local .env for machine-specific settings (tokens, paths, etc)
[ -f ~/.env ] && . ~/.env
