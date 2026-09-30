#!/usr/bin/env bash
# Envy prompt with hostname, path and Git state inside real working trees.
# Git moves to its own line below 70 columns.
#shellcheck shell=bash
#shellcheck disable=SC2034 # Expected behavior for themes.

SCM_THEME_PROMPT_DIRTY=" ${red?}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
SCM_THEME_PROMPT_PREFIX=" |"
SCM_THEME_PROMPT_SUFFIX="${green?}|"

GIT_THEME_PROMPT_DIRTY=" ${red?}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green?}✓"

# Bracket the branch name rather than upstream's bare parentheses, so the
# branch is visually distinct from the scm char and the dirty marker.
GIT_THEME_PROMPT_PREFIX=" [${yellow?}"
GIT_THEME_PROMPT_SUFFIX="${green?}]"

SCM_GIT_CHAR='± git'
SCM_GIT_UNTRACKED_CHAR="${bold_red?}•${normal?}"
SCM_GIT_UNSTAGED_CHAR="${bold_yellow?}•${normal?}"
SCM_GIT_STAGED_CHAR="${bold_green?}+${normal?}"
SCM_GIT_STASH_CHAR_PREFIX="${purple?}•"
SCM_GIT_STASH_CHAR_SUFFIX=" ${green?}("
SCM_GIT_SHOW_STASH_INFO=false

VIRTUALENV_THEME_PROMPT_PREFIX="${green?}ⓔ  "
VIRTUALENV_THEME_PROMPT_SUFFIX=""

function prompt_command() {
    local git_segment="" git_sep=" "
    if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == true ]]; then
        scm
        (( COLUMNS < 70 )) && git_sep=$'\n'
        git_segment="${git_sep}${bold_cyan?}$(scm_char)${green?}$(scm_prompt_info)"
    fi
    PS1="\n$(virtualenv_prompt)${purple?}\h ${reset_color?}in ${green?}\w${git_segment}\n \\\\${green?}→${reset_color?} "
}

safe_append_prompt_command prompt_command
