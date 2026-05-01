return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup({
        current_line_blame = false,
        signcolumn         = true,
        numhl              = false,
        linehl             = false,
      })

      local gs = require("gitsigns")

      vim.keymap.set("n", "<leader>gp", gs.preview_hunk,                     { desc = "Git preview hunk" })
      vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame,        { desc = "Git blame toggle" })
      vim.keymap.set("n", "<leader>gr", gs.reset_hunk,                       { desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>gd", gs.diffthis,                         { desc = "Git diff this" })
      vim.keymap.set("n", "]h",         function() gs.nav_hunk("next") end)
      vim.keymap.set("n", "[h",         function() gs.nav_hunk("prev") end)
    end,
  },
}
