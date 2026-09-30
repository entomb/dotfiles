# Tool paths and environment.
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export PATH="$HOME/.bun/bin:$HOME/.deno/bin:$HOME/.pulumi/bin:$PATH"
export PATH="$HOME/.opencode/bin:$HOME/.duckdb/cli/latest:$HOME/.fzf/bin:$PATH"
export EDITOR=nvim
export VISUAL=nvim
export AWS_EC2_METADATA_DISABLED=true
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1

# Everything below is interactive only.
case $- in
    *i*) ;;
    *) return ;;
esac

# History and readline.
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT='%F %T  '
shopt -s histappend cmdhist lithist globstar checkwinsize cdspell dirspell
bind 'set show-all-if-ambiguous on'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[1;2D": backward-word'
bind '"\e[1;2C": forward-word'
bind '"\e[1;6D": beginning-of-line'
bind '"\e[1;6C": end-of-line'
bind '"\C-h": backward-kill-word'
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Define Git aliases before Bash-it loads its alias completions.
alias gg='git status'
alias gl='git lg'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gco='git checkout'
alias grep='grep --color=auto'
alias python='python3'
alias pip='pip3'
alias json='jq'

# Bash-it loads the enabled plugins and completions normally.
export BASH_IT="$HOME/.bash_it"
export BASH_IT_THEME='envy'
export SCM_CHECK=true
export BASH_IT_COMMAND_DURATION=true
export BASH_COMPLETION=/usr/share/bash-completion/bash_completion
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" --glob "!node_modules/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
unset MAILCHECK
PS1='[\u@\h \W]\$ '
if [ -f "$BASH_IT/bash_it.sh" ]; then
    source "$BASH_IT/bash_it.sh"
    alias reload='bash-it reload'
elif [ -f "$BASH_COMPLETION" ]; then
    source "$BASH_COMPLETION"
fi

# Listing preferences override Bash-it's general aliases.
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
    alias l='eza -1 --group-directories-first'
    alias ll='eza -lah --group-directories-first'
else
    alias ls='ls --color=auto --group-directories-first'
    alias l='ls -1'
    alias ll='ls -lah'
fi

# fzf integration from the package or an optional user installation.
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
    [ -f /usr/share/doc/fzf/examples/completion.bash ] && source /usr/share/doc/fzf/examples/completion.bash
else
    [ -f "$HOME/.fzf/shell/key-bindings.bash" ] && source "$HOME/.fzf/shell/key-bindings.bash"
    [ -f "$HOME/.fzf/shell/completion.bash" ] && source "$HOME/.fzf/shell/completion.bash"
fi
if declare -F __fzf_cd__ >/dev/null; then
    bind -m emacs-standard -x '"\C-f": fzf-file-widget'
    bind -m emacs-standard '"\C-p": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\C-\e(\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d\C-y\ey\C-_"'
fi

# Optional integrations.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
[ -f "$HOME/open.sh" ] && source "$HOME/open.sh"
# Private variables and overrides load after the interactive configuration.
if [ -f "$HOME/.secret" ]; then
    source "$HOME/.secret"
fi
