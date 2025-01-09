-- Call Wezterm API
local wezterm = require("wezterm")

-- contains configuration
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("D2CodingLigature Nerd Font")
config.font_size = 18

-- Key mapping section
config.keys = {
	{ key = "n", mods = "OPT", action = wezterm.action({ SendString = "~" }) },
	{ key = "l", mods = "OPT", action = wezterm.action({ SendString = "@" }) },
	{ key = "p", mods = "OPT", action = wezterm.action({ SendString = "[" }) },
	{ key = "ü", mods = "OPT", action = wezterm.action({ SendString = "]" }) },
	{ key = "ö", mods = "OPT", action = wezterm.action({ SendString = "{" }) },
	{ key = "ä", mods = "OPT", action = wezterm.action({ SendString = "}" }) },
	{ key = "ä", mods = "OPT", action = wezterm.action({ SendString = "}" }) },
	{ key = "7", mods = "OPT", action = wezterm.action({ SendString = "|" }) },
	{ key = "+", mods = "OPT", action = wezterm.action({ SendString = "\\" }) },

	-- Map 'Command + v' to activate copy mode
	{
		key = "v",
		mods = "OPT",
		action = wezterm.action.ActivateCopyMode,
	},
}

-- Mouse and cursor
config.default_cursor_style = "BlinkingUnderline"
config.hide_mouse_cursor_when_typing = true

-- Scrollbar
config.enable_scroll_bar = true

return config
