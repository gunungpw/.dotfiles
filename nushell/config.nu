$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.buffer_editor = "code"
$env.config.shell_integration.osc133 = false

alias vw = overlay use .venv/Scripts/activate.nu # windows activate virtual environment
alias vl = overlay use .venv/bin/activate.nu # linux activate virtual environment

alias l = eza --sort type
alias ls = eza --sort type
alias la = eza -a --sort type
alias lh = eza -lh --sort type
alias uvr = uv run
