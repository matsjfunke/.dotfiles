return {
  -- nvim-ts-autotag for auto closing and renaming HTML tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = {
          "html",
          "xml",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
        },
        -- Add any additional options if needed
      })
    end,
  },
}
