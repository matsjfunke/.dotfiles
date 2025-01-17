return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { pane = 2, padding = 6 }, -- empty section to create space above cowsay
        {
          pane = 2,
          section = "terminal",
          cmd = "fortune computers cookie linuxcookie education science wisdom | cowsay -f Moofasa",
          indent = 15,
          height = 30,
          ttl = 0, -- Disable caching to get a new quote each time
        },
      },
    },
  },
}
