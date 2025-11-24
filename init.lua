--  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim


-- ========================================
-- Line numbers
-- ========================================
vim.opt.number = true
vim.opt.relativenumber = true


-- ========================================
-- Plugins (using packer)
-- ========================================
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- File explorer (like VS Code)
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
end)


-- ========================================
-- nvim-tree setup
-- ========================================
require('nvim-tree').setup()

-- Keybind to toggle the sidebar (Ctrl+N)
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

