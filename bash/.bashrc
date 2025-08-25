# Prevent duplicate lines or lines starting with a space in the history
HISTCONTROL=ignoredups:ignorespace

# Set history size (in-memory and file)
HISTSIZE=1000
HISTFILESIZE=2000
# Add timestamps to history entries
HISTTIMEFORMAT="%F %T "

# Append to the history file, don't overwrite it
shopt -s histappend

# Update window size after each command
shopt -s checkwinsize

# Prevent accidental overwrites with IO redirection
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

    local user_host
    if [[ -n "$CONTAINER_ID" ]]; then
        user_host="box:$CONTAINER_ID"
    else
        user_host="$HOSTNAME"
    fi
    local user_name=$(whoami)
    local working_dir=" \w"

    PS1="${BOLD}${user_name}@${user_host}${RESET}:${working_dir} ❭ "
}

# Set the prompt command
export PROMPT_COMMAND='generate_prompt'

# Alias
alias ..="cd .."
if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias la="eza -la"
    alias l="eza -l"
else
    alias la="ls -la"
    alias l="ls -l"
fi
alias rr="rm -r"

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

# Binary Directory Variable
export NIMBLE_BIN="$HOME/.nimble/bin"
export CARGO_BIN="$HOME/.cargo/bin"

# Add directory to PATH
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}
add_to_path "$XDG_BIN_HOME"
add_to_path "$NIMBLE_BIN"
add_to_path "$CARGO_BIN"

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi
