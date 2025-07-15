use std/util "path add"

def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def check_os [] {
    if (uname | get kernel-name) == "Windows_NT" {
        return $"(ansi blue_bold)WIN(ansi reset)"
    } else {
        return $"(ansi blue_bold)LIN(ansi reset)"
    }
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| $"(check_os) (create_left_prompt) " }
$env.PROMPT_COMMAND_RIGHT = {||}

# XDG - Base Directory Specification
$env.XDG_CONFIG_HOME = $nu.home-path | path join .dotfiles
$env.XDG_BIN_HOME = $nu.home-path | path join .local bin
$env.XDG_DATA_HOME = $nu.home-path | path join .local share
$env.XDG_CACHE_HOME = $nu.home-path | path join .local cache
$env.XDG_STATE_HOME = $nu.home-path | path join .local state

# Configuration Environment Variable
$env.GIT_CONFIG_GLOBAL = $env.XDG_CONFIG_HOME | path join git .gitconfig

# Cache Environment Variable
$env.UV_PYTHON_INSTALL_DIR = $nu.home-path | path join .local py
$env.UV_CACHE_DIR = $env.XDG_CACHE_HOME | path join uv
$env.UV_TOOL_DIR = $env.XDG_DATA_HOME | path join uv tools
$env.UV_TOOL_BIN_DIR = $env.XDG_BIN_HOME
$env.BUN_INSTALL_DIR_CACHE = $nu.home-path | path join .local cache

# History Environment Variable
$env.NODE_REPL_HISTORY = $env.XDG_DATA_HOME | path join history_node
$env.LESSHISTFILE = $env.XDG_DATA_HOME | path join history_less
$env.PYTHON_HISTORY = $env.XDG_DATA_HOME | path join history_python
$env._ZO_DATA_DIR = $env.XDG_DATA_HOME | path join zoxide

# Add directory to PATH
path add $env.XDG_BIN_HOME

$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.buffer_editor = "hx"
$env.config.shell_integration.osc133 = false

alias vw = overlay use .venv/Scripts/activate.nu # windows activate virtual environment
alias vl = overlay use .venv/bin/activate.nu # linux activate virtual environment

alias uvr = uv run
alias rr = rm --recursive
alias l = ls

# Custom commands
def see [file] { open $file --raw  | nu-highlight }
def ll [] { ls | sort-by type } # Alias for ls and sort-by type
def la [] { ls --all | sort-by type } # Alias for show all hidden and sort-by type

# Check binary version
def check-system [] {
    cd ($env.XDG_CONFIG_HOME | path join script);
    uv run check_version.py;
}

source zoxide.nu
