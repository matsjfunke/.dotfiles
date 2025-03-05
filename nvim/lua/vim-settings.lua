-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Map leader to <Space>
vim.g.mapleader = " "

-- Remap escape
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('v', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('c', 'kj', '<Esc>', { noremap = true })

-- Tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- sync to system clipboard
vim.opt.clipboard = "unnamedplus"

-- scroll cursor middle
vim.opt.scrolloff = 999

-- Colors
vim.opt.termguicolors = true

-- Auto-insert template based on filetype
vim.cmd([[
    autocmd BufNewFile *.py :0r ~/.dotfiles/nvim/lua/templates/python.tpl | $d
    autocmd BufNewFile *.html :0r ~/.dotfiles/nvim/lua/templates/html.tpl | $d
    autocmd BufNewFile .gitignore :0r ~/.dotfiles/nvim/lua/templates/gitignore.tpl | $d
    autocmd BufNewFile Dockerfile :0r ~/.dotfiles/nvim/lua/templates/Dockerfile.tpl | $d
    autocmd BufNewFile docker-compose.yml :0r ~/.dotfiles/nvim/lua/templates/docker-compose.tpl | $d
]])

-- Split right
vim.o.splitright = true
vim.api.nvim_set_keymap('n', '<leader>ss', ':vsplit<CR>', { noremap = true, silent = true })
