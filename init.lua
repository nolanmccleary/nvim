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
vim.opt.termguicolors = true
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
      highlight = { enable = true },
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
    --{
    --    "rebelot/kanagawa.nvim",
    --    lazy = false,
    --    priority = 1000,
    --},
    {
        "vague-theme/vague.nvim",
        lazy = false,
        priority = 1000,
    },
  },
})


require'nvim-treesitter'.setup {
    install_dir = vim.fn.stdpath('data') .. '/site'
}


require'nvim-treesitter'.install { 'c', 'cpp', 'python', 'lua', 'verilog', 'systemverilog', 'make', 'cmake'}


vim.keymap.set("n", "<leader>y", ":%y<CR>", { silent = true, desc = "Copy entire file to clipboard" })
vim.keymap.set({ "n", "v" }, "j", "k", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "j", { noremap = true, silent = true })
vim.keymap.set("n", "[b", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "]b", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { silent = true })
vim.keymap.set("n", "<leader>vst", ":vsplit | term<CR>", {silent = true })
vim.keymap.set("n", "<leader>st", ":split | term<CR>", {silent = true })
vim.keymap.set("n", "<leader>cwd", ":lua require('nvim-tree.api').tree.change_root(vim.fn.getcwd())<CR>", {silent = true}) 


--Use Zathura to open PDF files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'pdf',
    callback = function (args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        vim.fn.jobstart({ 'zathura', file}, { detach = true })
        vim.api.nvim_buf_delete(args.buf, { force = true })
    end,
})


-- Use rga so that telescope can search inside PDF files too
do
  local ok, telescope = pcall(require, "telescope")
  if ok then
    local vimgrep = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }

    if vim.fn.executable("rga") == 1 then
      vimgrep = { "rga", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
    end

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep,
      },
    })
  end
end


--require("kanagawa").setup({ transparent = true })
vim.cmd.colorscheme("vague")
