local wezterm = require "wezterm"
local mux = wezterm.mux

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window{}
    window:gui_window():maximize()
  end)

local config = {}

-- Settings for looks
config.color_scheme = "Mathias (Gogh)"
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 10.0
config.font =
    wezterm.font_with_fallback {
    "Cascadia Code NF",
	"Fira Code",
    --'FiraCode Nerd Font Mono',
    --'CaskaydiaCove Nerd Font Mono',
}

-- Default Shell
config.default_prog = {
    "nu"
}

config.max_fps = 60

config.initial_cols = 160
config.initial_rows = 30

return config
