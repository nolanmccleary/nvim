return {
  {
    "savq/melange-nvim",
    lazy     = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("melange")

      vim.api.nvim_set_hl(0, "FlashLabel",   { fg = "#ff0000", bg = "NONE", bold = false })
      vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#ff0000", bg = "NONE", bold = false })

      vim.api.nvim_set_hl(0, "StatusLine",      { fg = "#5a7a6a", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "StatusLineNC",     { fg = "#333333", bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineTerm",   { fg = "#5a7a6a", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "StatusLineTermNC", { fg = "#333333", bg = "NONE" })

      vim.api.nvim_set_hl(0, "MsgArea", { fg = "#997db1" })
      vim.api.nvim_set_hl(0, "ModeMsg", { fg = "#997db1" })
      vim.api.nvim_set_hl(0, "CmdLine", { fg = "#997db1" })

      vim.api.nvim_set_hl(0, "LineNr",      { fg = "#88b0b0" })
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#997db1" })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#997db1" })

      vim.api.nvim_set_hl(0, "ActiveLineNr",   { fg = "#997db1", bold = true })
      vim.api.nvim_set_hl(0, "InactiveLineNr", { fg = "#444444" })
    end,
  },
}
