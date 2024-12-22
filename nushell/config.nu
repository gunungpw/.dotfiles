
# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
    display_errors: { exit_code: false }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    footer_mode: 25 # always, never, number_of_rows, auto
    float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: null # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: emacs # emacs, vi
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: true
        osc133: false
        osc633: true
        reset_application_mode: true
    }
}

# windows activate virtual environment
alias vw = overlay use .venv/Scripts/activate.nu
# linux activate virtual environment
alias vl = overlay use .venv/bin/activate.nu

alias ls = eza --sort type
alias la = eza -a --sort type
alias lh = eza -lh --sort type
alias uvr = uv run
