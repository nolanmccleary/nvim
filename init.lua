-- git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.g.mapleader = " "

-- ===== plugins =====
require("lazy").setup({
  -- Install missing plugins automatically on startup
  install = { missing = true },

  spec = {
    {
      "nvim-tree/nvim-tree.lua",
      lazy=false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<cr>", silent = true },
      },
      config = function()
        pcall(function()
          require("nvim-web-devicons").setup({ default = true })
        end)
        pcall(function()
          require("nvim-tree").setup({
            renderer = {
              icons = {
                show = { file = true, folder = true, folder_arrow = true, git = true },
              },
            },
            git = { enable = true, ignore = false },
          })
        end)
      end,
    },

    {
      "ellisonleao/glow.nvim",
      cmd = "Glow",
      keys = {
        { "<leader>mp", "<cmd>Glow<cr>", desc = "Markdown Preview" },
      },
      config = function()
        pcall(function() require("glow").setup() end)
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      lazy=false,
      build = ":TSUpdate",
    },

    {
      "nvim-telescope/telescope.nvim",
      lazy=false,
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "Telescope",
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", silent = true },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", silent = true },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", silent = true },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", silent = true },
      },
    },

    {
      "neovim/nvim-lspconfig",
      lazy=false,
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
        pcall(require, "lsp")
      end,
    },
  },
})

require'nvim-treesitter'.setup {
    install_dir = vim.fn.stdpath('data') .. '/site'
}

require'nvim-treesitter'.install { 'c', 'python', 'lua', 'verilog'}

vim.keymap.set("n", "<leader>y", ":%y<CR>", { silent = true, desc = "Copy entire file to clipboard" })
vim.keymap.set({ "n", "v" }, "j", "k", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "j", { noremap = true, silent = true })

vim.api.nvim_create_autocmd('FileType', {
    pattern = { '<filetype>' },
    callback = function() vim.treesitter.start() end,
})
