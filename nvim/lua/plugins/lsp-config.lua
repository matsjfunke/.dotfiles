return {
    {
        -- manage and install lsps on system
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        -- ensures that set lsp's are installed
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "cssls", "html", "tsserver", "rust_analyzer" },
            })
        end,
    },
    {
        -- allows communication between lsps and nvim
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})
            lspconfig.cssls.setup({})
            lspconfig.html.setup({})
            lspconfig.tsserver.setup({})
            lspconfig.rust_analyzer.setup({})

            -- Set up key mappings for LSP commands
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            -- show information about the symbol under the cursor (documentation / type information)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            -- go to definition
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
            -- trigger code actions fixing code issues / refactoring code
        end,
    },
}
