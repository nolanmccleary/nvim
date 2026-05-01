return {
  {
    "ellisonleao/glow.nvim",
    cmd  = "Glow",
    keys = {
      { "<leader>mp", "<cmd>Glow<cr>", desc = "Markdown Preview" },
    },
    config = function()
      pcall(function() require("glow").setup() end)
    end,
  },
}
