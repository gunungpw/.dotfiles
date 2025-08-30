use std/util "path add"
use library/function.nu [
    create_left_prompt,
    down,
    get_username,
    get_hostname,
    get_container_id,
    l,
    la,
    y,
]

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| $"(ansi yellow_bold)(get_username)@(get_hostname)(ansi reset)(get_container_id): (create_left_prompt) " }
$env.PROMPT_COMMAND_RIGHT = {||}

# XDG - Base Directory Specification
$env.XDG_CONFIG_HOME = $nu.home-path | path join .local dotfiles
$env.XDG_BIN_HOME = $nu.home-path | path join .local bin
$env.XDG_DATA_HOME = $nu.home-path | path join .local share
$env.XDG_CACHE_HOME = $nu.home-path | path join .local cache
$env.XDG_STATE_HOME = $nu.home-path | path join .local state

# Configuration Environment Variable
$env.GIT_CONFIG_GLOBAL = $env.XDG_CONFIG_HOME | path join git .gitconfig
$env.EDITOR = "micro"

# Cache Environment Variable
$env.UV_PYTHON_INSTALL_DIR = $nu.home-path | path join .local py
$env.UV_CACHE_DIR = $env.XDG_CACHE_HOME | path join uv
$env.UV_TOOL_DIR = $env.XDG_DATA_HOME | path join uv tools
$env.UV_TOOL_BIN_DIR = $env.XDG_BIN_HOME
$env.BUN_INSTALL = $nu.home-path | path join .local
$env.BUN_INSTALL_DIR_CACHE = $nu.home-path | path join .local cache

# History Environment Variable
$env.HISTORY_DIR = $nu.home-path | path join .local history
$env.NODE_REPL_HISTORY = $env.HISTORY_DIR | path join history_node
$env.LESSHISTFILE = $env.HISTORY_DIR | path join history_less
$env.PYTHON_HISTORY = $env.HISTORY_DIR | path join history_python
$env._ZO_DATA_DIR = $env.HISTORY_DIR | path join zoxide

# Binary Directory Variable
$env.NIMBLE_BIN = $nu.home-path | path join .nimble bin
$env.CARGO_BIN = $nu.home-path | path join .cargo bin
$env.ZIG_BIN = $nu.home-path | path join .zig

# Add directory to PATH
path add $env.XDG_BIN_HOME
path add $env.NIMBLE_BIN
path add $env.CARGO_BIN
path add $env.ZIG_BIN

$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.shell_integration.osc133 = true
$env.config.completions.algorithm = "fuzzy"

alias vw = overlay use .venv/Scripts/activate.nu # windows activate virtual environment
alias vl = overlay use .venv/bin/activate.nu # linux activate virtual environment

alias vv = uv run
alias rr = rm --recursive
alias de = distrobox enter # enter distrobox container

source zoxide.nu
source atuin.nu
