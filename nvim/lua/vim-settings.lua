-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Map leader to <Space>
vim.g.mapleader = " "

-- Remap escape
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('v', 'kj', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('c', 'kj', '<Esc>', {noremap = true})

-- Tab
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- sync to system clipboard
vim.opt.clipboard = "unnamedplus"

-- scroll cursor middle
vim.opt.scrolloff = 999

-- colors
vim.opt.termguicolors = true
