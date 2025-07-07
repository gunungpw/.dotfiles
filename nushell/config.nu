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
