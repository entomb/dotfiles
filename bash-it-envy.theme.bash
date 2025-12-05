#!/usr/bin/env bash
# Custom Envy Theme for Bash-it
# Place this in: ~/.bash_it/themes/envy/envy.theme.bash

SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ( ${green}"
GIT_THEME_PROMPT_SUFFIX=" ${green})"
SCM_GIT_CHAR='± git'
SCM_GIT_UNTRACKED_CHAR="${bold_red}•${normal}"
SCM_GIT_UNSTAGED_CHAR="${bold_yellow}•${normal}"
SCM_GIT_STAGED_CHAR="${bold_green}+${normal}"
SCM_GIT_STASH_CHAR_PREFIX="${purple}•"
SCM_GIT_STASH_CHAR_SUFFIX=" ${green}("
SCM_GIT_SHOW_STASH_INFO=false

GIT_THEME_PROMPT_DIRTY=" ${red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"

VIRTUALENV_THEME_PROMPT_PREFIX="${green}ⓔ  "
VIRTUALENV_THEME_PROMPT_SUFFIX=""

function prompt_command() {
    # Custom PS1 - removed ruby version prompt from original envy theme
    # Original line (with ruby): PS1="\n$(virtualenv_prompt)${yellow}$(ruby_version_prompt) ${purple}\h ${reset_color}in ${green}\w\n${bold_cyan}$(scm_char)${green}$(scm_prompt_info) ${green}→${reset_color} "
    PS1="\n$(virtualenv_prompt)${purple}\h ${reset_color}in ${green}\w\n${bold_cyan}$(scm_char)${green}$(scm_prompt_info) ${green}\$${reset_color} "
}

safe_append_prompt_command prompt_command
