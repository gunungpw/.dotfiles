use std "path add"

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

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| $"(ansi dgrb)(sys host | get hostname)(ansi reset) (create_left_prompt) " }
$env.PROMPT_COMMAND_RIGHT = {||}

# Environment Variable
$env.XDG_CONFIG_HOME = $nu.home-path | path join .dotfiles
$env.XDG_BIN_HOME = $nu.home-path | path join .local bin
$env.XDG_DATA_HOME = $nu.home-path | path join .local share
$env.UV_PYTHON_INSTALL_DIR = $nu.home-path | path join .local py
$env.GIT_CONFIG_GLOBAL = $nu.home-path | path join .dotfiles git .gitconfig

# Add directory to PATH
path add $env.XDG_BIN_HOME
