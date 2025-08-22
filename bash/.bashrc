# don't put duplicate lines in the history.
HISTCONTROL=ignoredups:ignorespace
# for setting history length see HISTSIZE and HISTFILESIZE
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

## Enables displaying colors in the terminal
export TERM=xterm-color

## Prevent accidental overwrites when using IO redirection
set -o noclobber

## Set the prompt to display the current git branch
## and use pretty colors
# Function to generate custom bash prompt
generate_prompt() {
    # Colors
    local BOLD='\[\e[1m\]'
    local BLUE='\[\e[34m\]'
    local RED='\[\e[1;31m\]'
    local RESET='\[\e[0m\]'

    # Base prompt components
    local user_host="${BOLD}\u@\h${RESET}"
    local working_dir=" \w"

    # Check if we're in a git repository
    if git branch &>/dev/null; then
        # Get current branch
        local branch=$(git branch | grep '^*' | sed 's/^* //')
        
        # Check if working directory is clean
        local status_indicator=""
        if ! git status | grep "nothing to commit" >/dev/null 2>&1; then
            status_indicator="${RED}*${RESET}"
        fi
        
        # Construct prompt with git info
        PS1="${user_host}:${working_dir} [${BLUE}${branch}${RESET}${status_indicator}] \$ "
    else
        # Construct prompt without git info
        PS1="${user_host}:${working_dir} \$ "
    fi
}

# Set the prompt command
export PROMPT_COMMAND='generate_prompt'

# Alias
alias ..="cd .."
alias la="eza -la"
alias l="eza -l"

# XDG - Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.dotfiles"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Configuration Environment Variable
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig"
export EDITOR="micro"

# Cache Environment Variable
export UV_PYTHON_INSTALL_DIR="$HOME/.local/py"
export UV_CACHE_DIR="$XDG_CACHE_HOME/uv"
export UV_TOOL_DIR="$XDG_DATA_HOME/uv/tools"
export UV_TOOL_BIN_DIR="$XDG_BIN_HOME"
export BUN_INSTALL="$HOME/.local"
export BUN_INSTALL_DIR_CACHE="$HOME/.local/cache"

# History Environment Variable
export NODE_REPL_HISTORY="$XDG_DATA_HOME/history_node"
export LESSHISTFILE="$XDG_DATA_HOME/history_less"
export PYTHON_HISTORY="$XDG_DATA_HOME/history_python"
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
export HISTFILE="$XDG_DATA_HOME/bash_history"

# Add directory to PATH
export PATH="$XDG_BIN_HOME:$PATH"
