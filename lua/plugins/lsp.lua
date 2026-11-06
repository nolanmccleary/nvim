return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Servers Mason installs and keeps updated, into ~/.local/share/nvim/mason.
        -- rust-analyzer stays on rustup and slang-server is a manual build, so
        -- neither is listed here.
        ensure_installed = {
          "clangd",
          "ts_ls",
          "asm_lsp",
          "tinymist",
          "pyright",
          "hls",
          "bashls",
          "lua_ls",
        },
        -- Servers are enabled explicitly in lsp.lua, so don't auto-enable here.
        automatic_enable = false,
      })
      require("lsp")
    end,
  },
}
