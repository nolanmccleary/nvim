--  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim


vim.opt.expandtab = true   
vim.opt.shiftwidth = 4     
vim.opt.tabstop = 4        
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true  
vim.opt.smartcase = true   
-- vim.opt.termguicolors = true
vim.opt.signcolumn = "yes" 
vim.opt.swapfile = false
vim.opt.undofile = true   
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.o.completeopt = "menuone,noinsert,noselect"

require("lsp")

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use { "ellisonleao/glow.nvim", branch = "main" }

    use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
        }
  
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
end)

require("glow").setup()

require('nvim-web-devicons').setup {
    default = true,  -- use default icons when no match
}

require('nvim-tree').setup {
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,   -- git status icons
            },
        },
    },
    git = {
        enable = true,
        ignore = false,
    },
}

require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "json", "python" }, -- pick what you use
    highlight = {
        enable = true,
    },
}


vim.g.mapleader = ' '

vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>mp', ':Glow<CR>', { desc = "Markdown Preview" })

vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { silent = true })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { silent = true })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { silent = true })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { silent = true })

vim.keymap.set(
  'n',
  '<leader>y',
  ':%y<CR>',
  { silent = true, desc = 'Copy entire file to clipboard' }
)

vim.keymap.set({ 'n', 'v' }, 'j', 'k', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'j', { noremap = true, silent = true })

vim.opt.number = true
vim.opt.relativenumber = false

