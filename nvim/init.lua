vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' }},

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	{ 'joshdick/onedark.vim', priority = 1000 },

	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim",}}
}, 
{})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

vim.keymap.set('n', '<C-s>', ':Neotree toggle<CR>')		

local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "html", "python", "rust", "css", "dockerfile", "go", "json", "markdown", "ruby", "sql", "yaml" },
	highlight = { enable = true },
        indent = { enable = true },
	})

vim.cmd("colorscheme onedark")
