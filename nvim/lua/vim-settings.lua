-- Line numbers
vim.o.number = true 

-- Map leader to <Space>
vim.g.mapleader = " "

-- Remap escape
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('v', 'kj', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('c', 'kj', '<Esc>', {noremap = true})
