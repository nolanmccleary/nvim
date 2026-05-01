return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy  = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
        highlight   = { enable = true },
      })
      require("nvim-treesitter").install({
        "c", "cpp", "python", "lua",
        "verilog", "systemverilog",
        "make", "cmake",
      })
    end,
  },
}
