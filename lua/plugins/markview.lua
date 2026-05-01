return {
  {
    "OXY2DEV/markview.nvim",
    ft           = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("markview").setup({})
      vim.keymap.set("n", "<leader>mr", "<cmd>Markview<cr>", { desc = "Toggle Markview render" })
    end,
  },
}
