return {
    -- fuzzyfind files in nvim
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        require('telescope').setup{
            defaults = {
                mappings = {
                    i = { ["<C-h>"] = "which_key" }
                }
            },
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
            },
        }
    end
}
