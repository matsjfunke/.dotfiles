-- Call Wezterm API
local wezterm = require("wezterm")

-- contains configuration
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("D2CodingLigature Nerd Font")
config.font_size = 18

-- Key mapping section
config.keys = {
  {key="n", mods="OPT", action=wezterm.action{SendString="~"}},
}

-- Mouse and cursor
config.default_cursor_style = "BlinkingUnderline"
config.hide_mouse_cursor_when_typing = true

-- Scrollbar
config.enable_scroll_bar = true

return config
