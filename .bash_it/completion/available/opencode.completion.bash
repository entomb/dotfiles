# shellcheck shell=bash
about-completion "OpenCode CLI completion"

_bash-it-completion-helper-necessary opencode || return
_bash-it-completion-helper-sufficient opencode || return

eval "$(opencode --completions bash)"
