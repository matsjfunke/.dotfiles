return {
    -- Harpoon for quick file navigation
    "ThePrimeagen/harpoon",
    -- nvim-lua/plenary.nvim is a dependency but already definded in telescope
    dependencies = {},
    config = function()
        local harpoon = require("harpoon")
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        -- Set keybindings for Harpoon
        vim.keymap.set("n", "hx", mark.add_file, { desc = "Add File to Harpoon" })
        -- show all marks
        vim.keymap.set("n", "hm", ui.toggle_quick_menu, { desc = "Toggle Harpoon Menu" })
        -- Cycle through files
        vim.keymap.set("n", "hn", ui.nav_next, { desc = "Navigate to next File" })
        vim.keymap.set("n", "hp", ui.nav_prev, { desc = "Navigate to previous File" })

        -- Map files to keys
        vim.keymap.set("n", "h1", function()
            ui.nav_file(1)
        end, { desc = "Navigate to file 1" })
        vim.keymap.set("n", "h2", function()
            ui.nav_file(2)
        end, { desc = "Navigate to file 2" })
        vim.keymap.set("n", "h3", function()
            ui.nav_file(3)
        end, { desc = "Navigate to file 3" })
        vim.keymap.set("n", "h4", function()
            ui.nav_file(4)
        end, { desc = "Navigate to file 4" })

        harpoon.setup({
            global_settings = {
                -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                save_on_toggle = false,
                -- saves the harpoon file upon every change. disabling is unrecommended.
                save_on_change = true,
                -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                enter_on_sendcmd = false,
                -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                tmux_autoclose_windows = false,
                -- filetypes that you want to prevent from adding to the harpoon list menu.
                excluded_filetypes = { "harpoon" },
                -- set marks specific to each git branch inside git repository
                mark_branch = true,
                -- enable tabline with harpoon marks
                tabline = false,
                tabline_prefix = "   ",
                tabline_suffix = "   ",
            },
        })
    end,
}
