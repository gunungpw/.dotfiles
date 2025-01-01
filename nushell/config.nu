$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.buffer_editor = "hx"
$env.config.shell_integration.osc133 = false

alias vw = overlay use .venv/Scripts/activate.nu # windows activate virtual environment
alias vl = overlay use .venv/bin/activate.nu # linux activate virtual environment

alias uvr = uv run

# Custom commands
def see [file] {
    open $file --raw  | nu-highlight
}

source zoxide.nu
