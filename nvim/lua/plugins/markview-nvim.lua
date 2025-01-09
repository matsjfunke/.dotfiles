return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local checkbox_presets = require("markview.presets").checkboxes

			require("markview").setup({
				checkboxes = checkbox_presets.nerd,
			})
		end,
	},
}
