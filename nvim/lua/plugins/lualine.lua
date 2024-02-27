return {
    -- pretty Neovim statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'nightfly',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
        }
    end
}
