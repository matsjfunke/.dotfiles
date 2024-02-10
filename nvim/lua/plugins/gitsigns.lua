return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()

        -- what changed in the line
        vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
        -- who and when changed the line
        vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
    end,
}
