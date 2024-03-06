return {
    -- wraps linters/formatters to make them seem like an normal lsp to nvim-lspconfig
	-- still need to install linters and formatters with mason 
        -- :Mason   =>    /linter_name <CR>     =>      i (to install linter/fromatter)
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.isort,
                null_ls.builtins.diagnostics.eslint_d,
                null_ls.builtins.diagnostics.flake8.with({extra_args = {"--max-line-length","100"}}),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
