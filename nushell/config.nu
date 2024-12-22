$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
    display_errors: { exit_code: false }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

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

alias l = eza --sort type
alias ls = eza --sort type
alias la = eza -a --sort type
alias lh = eza -lh --sort type
alias uvr = uv run
