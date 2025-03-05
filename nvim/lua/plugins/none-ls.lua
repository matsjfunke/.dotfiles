return {
  -- wraps linters/formatters to make them seem like an normal lsp to nvim-lspconfig
  -- still need to install linters and formatters with mason
  -- :Mason   =>    /linter_name <CR>     =>      i (to install linter/fromatter)
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.isort,
        require("none-ls.diagnostics.flake8").with({ extra_args = { "--max-line-length", "155" } }),
        null_ls.builtins.formatting.black.with({ extra_args = { "--line-length", "155" } }),
        null_ls.builtins.formatting.prettierd,
      },
    })

    -- Autoformat on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      pattern = "*",
      callback = function()
        vim.lsp.buf.format({ async = true })
      end,
    })

    vim.keymap.set("n", "<leader>sf", vim.lsp.buf.format, {})
  end,
}
