# shellcheck shell=bash
about-completion "Codex CLI completion"

_bash-it-completion-helper-necessary codex || return
_bash-it-completion-helper-sufficient codex || return

eval "$(codex completion bash)"
