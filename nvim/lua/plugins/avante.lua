return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    opts = {
      provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-7-sonnet-20250219",
        temperature = 0.4,
        max_tokens = 8000,
      },
      behaviour = {
        enable_cursor_planning_mode = true, -- Enable planning mode for better context
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Syntax highlighting
      "stevearc/dressing.nvim",       -- UI enhancements
      "nvim-lua/plenary.nvim",        -- Lua utilities
      "MunifTanjim/nui.nvim",         -- UI components
      "nvim-tree/nvim-web-devicons",  -- File icons
      {
        "HakonHarnes/img-clip.nvim",  -- For image pasting
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim", -- Markdown rendering
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
