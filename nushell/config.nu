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

def get_git_branch [] {
    if (which git | is-empty) {
        return ""
    }

    let git_current_ref = (do { git rev-parse --abbrev-ref HEAD } | complete | get stdout | str trim)
    if ($git_current_ref != "") {
        return $" (ansi cyan_bold)[($git_current_ref)](ansi reset)"
    }

    return ""
}

def container [] {
	if ($env.CONTAINER_ID? | is-empty) == false {
		return $"(ansi purple_bold) [box:($env.CONTAINER_ID)](ansi reset)"
	} else {
		""
	}
 
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| $"(ansi blue_bold)($env.USER)@($env.HOSTNAME)(ansi reset)(container)(get_git_branch): (create_left_prompt)\n" }
$env.PROMPT_COMMAND_RIGHT = {||}

# XDG - Base Directory Specification
$env.XDG_CONFIG_HOME = $nu.home-path | path join .dotfiles
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
$env.BUN_INSTALL_DIR_CACHE = $nu.home-path | path join .local cache

# History Environment Variable
$env.NODE_REPL_HISTORY = $env.XDG_DATA_HOME | path join history_node
$env.LESSHISTFILE = $env.XDG_DATA_HOME | path join history_less
$env.PYTHON_HISTORY = $env.XDG_DATA_HOME | path join history_python
$env._ZO_DATA_DIR = $env.XDG_DATA_HOME | path join zoxide

# Special Binary Path
$env.BUN_BIN_PATH = $nu.home-path | path join .bun bin

# Add directory to PATH
path add $env.XDG_BIN_HOME
path add $env.BUN_BIN_PATH

$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.shell_integration.osc133 = false

alias vw = overlay use .venv/Scripts/activate.nu # windows activate virtual environment
alias vl = overlay use .venv/bin/activate.nu # linux activate virtual environment

alias vv = uv run
alias rr = rm --recursive

# Custom commands
def see [file] { open $file --raw  | nu-highlight }
def l [] { ls | sort-by type } # Alias for ls and sort-by type
def la [] { ls --all | sort-by type } # Alias for show all hidden and sort-by type

# Check binary version
def check-system [] {
    cd ($env.XDG_CONFIG_HOME | path join script);
    uv run check_version.py;
}

# Yazi shortcut CWD
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

source zoxide.nu
