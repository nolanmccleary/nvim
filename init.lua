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
vim.opt.whichwrap:append("<,>,h,l,[,]")

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
        local function ovrd_on_attach(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return {desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', 'vl', function()
                vim.opt.splitright = false
                api.node.open.vertical()
            end, opts('Vertical Split Left'))

            vim.keymap.set('n', 'vr', function()
                vim.opt.splitright = true
                api.node.open.vertical()
            end, opts('Vertical Split Right'))
        end

          require("nvim-tree").setup({
            on_attach = ovrd_on_attach,
            renderer = {
              icons = {
                show = { file = true, folder = true, folder_arrow = true, git = true },
              },
            },
            git = { enable = true, ignore = false },
          })
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

    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require("gitsigns").setup({
                current_line_blame = false,
                signcolumn = true,
                numhl = false,
                linehl = false,
            })

            vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Git preview hunk" })
            vim.keymap.set("n", "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Git blame toggle" })
            vim.keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "Git diff this" })
            vim.keymap.set("n", "]h", function() require("gitsigns").next_hunk() end, { desc = "Next git hunk" })
            vim.keymap.set("n", "[h", function() require("gitsigns").prev_hunk() end, { desc = "Prev git hunk" })
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
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })


local history = {} -- Structure: { [win_id] = { index = 1, list = { buf1, buf2 } } }

local function update_history()
    local win_id = vim.api.nvim_get_current_win()
    local buf_id = vim.api.nvim_get_current_buf()

    if vim.bo.buftype ~= "" or vim.bo.filetype == "NvimTree" then return end

    if not history[win_id] then
        history[win_id] = { index = 1, list = { buf_id } }
        return
    end

    local win_hist = history[win_id]
    
    if win_hist.list[win_hist.index] == buf_id then return end

    while #win_hist.list > win_hist.index do
        table.remove(win_hist.list)
    end

    table.insert(win_hist.list, buf_id)
    win_hist.index = #win_hist.list
end

local function cleanup_history(args)
    local deleted_buf = args.buf
    for win_id, win_hist in pairs(history) do
        for i = #win_hist.list, 1, -1 do
            if win_hist.list[i] == deleted_buf then
                table.remove(win_hist.list, i)
                if win_hist.index >= i and win_hist.index > 1 then
                    win_hist.index = win_hist.index - 1
                end
            end
        end
    end
end

vim.api.nvim_create_autocmd("BufEnter", { callback = update_history })
vim.api.nvim_create_autocmd("BufDelete", { callback = cleanup_history })

local function navigate_local_history(delta)
    local win_id = vim.api.nvim_get_current_win()
    local win_hist = history[win_id]

    if not win_hist or #win_hist.list == 0 then 
        print("No local history for this window")
        return 
    end

    local new_index = win_hist.index + delta
    if new_index >= 1 and new_index <= #win_hist.list then
        win_hist.index = new_index
        local target_buf = win_hist.list[new_index]
        if vim.api.nvim_buf_is_valid(target_buf) then
            vim.api.nvim_set_current_buf(target_buf)
        end
    else
        print(delta > 0 and "At newest jump" or "At oldest jump")
    end
end

vim.keymap.set("n", "[c", function() navigate_local_history(-1) end, { desc = "Local Back" })
vim.keymap.set("n", "]c", function() navigate_local_history(1) end, { desc = "Local Forward" })



local function is_swappable_win(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local bt = vim.bo[buf].buftype
  local ft = vim.bo[buf].filetype
  if ft == "NvimTree" then return false end
  if bt == "prompt" then return false end
  return true
end

local function ordered_wins_lr()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local out = {}
  for _, w in ipairs(wins) do
    if is_swappable_win(w) then
      table.insert(out, w)
    end
  end
  table.sort(out, function(a, b)
    local pa = vim.api.nvim_win_get_position(a) -- {row, col}
    local pb = vim.api.nvim_win_get_position(b)
    if pa[2] == pb[2] then
      return pa[1] < pb[1]
    end
    return pa[2] < pb[2]
  end)
  return out
end

local function swap_with_wrap(dir) -- dir = -1 (left) or +1 (right)
  local curwin = vim.api.nvim_get_current_win()
  local wins = ordered_wins_lr()

  if #wins < 2 then
    print("Need at least 2 swappable windows")
    return
  end

  local idx = nil
  for i, w in ipairs(wins) do
    if w == curwin then idx = i; break end
  end
  if not idx then
    print("Current window is not swappable")
    return
  end

  local n = #wins
  local nidx = ((idx - 1 + dir) % n) + 1
  local neighwin = wins[nidx]

  if neighwin == curwin then return end

  local curbuf = vim.api.nvim_win_get_buf(curwin)
  local neighbuf = vim.api.nvim_win_get_buf(neighwin)

  vim.api.nvim_win_set_buf(curwin, neighbuf)
  vim.api.nvim_win_set_buf(neighwin, curbuf)

  if history then
    history[curwin], history[neighwin] = history[neighwin], history[curwin]
  end
end

vim.keymap.set("n", "[s", function() swap_with_wrap(-1) end, { desc = "Swap with left window (wrap)" })
vim.keymap.set("n", "]s", function() swap_with_wrap( 1) end, { desc = "Swap with right window (wrap)" })



--Use Zathura to open PDF files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'pdf',
    callback = function (args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        vim.fn.jobstart({ 'zathura', file}, { detach = true })
        vim.api.nvim_buf_delete(args.buf, { force = true })
    end,
})


do
  local ok, telescope = pcall(require, "telescope")
  if ok then
    local vimgrep = { 
      "rg", 
      "--color=never", 
      "--no-heading", 
      "--with-filename", 
      "--line-number", 
      "--column", 
      "--smart-case",
      "--no-ignore", 
      "--hidden"     
    }

    if vim.fn.executable("rga") == 1 then
      vimgrep = { 
        "rga", 
        "--color=never", 
        "--no-heading", 
        "--with-filename", 
        "--line-number", 
        "--column", 
        "--smart-case",
        "--no-ignore", 
        "--hidden"
      }
    end

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep,
      },
      pickers = {
        find_files = {
          no_ignore = true,
          hidden = true,
        },
        live_grep = {
           additional_args = function(opts)
                return {"--no-ignore", "--hidden"}
           end
        }
      }
    })
  end
end




-- Use GTKWave for waveform dumps
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.fst", "*.vcd" },
  callback = function(args)
    local file = args.match  -- full path Neovim is trying to read

    if vim.fn.executable("gtkwave") ~= 1 then
      vim.notify("gtkwave not found in PATH", vim.log.levels.WARN)
      return
    end

    local alt = vim.fn.bufnr("#")
    if alt > 0 and vim.api.nvim_buf_is_valid(alt) then
      vim.cmd("buffer #")
    else
      vim.cmd("enew")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
      vim.bo.swapfile = false
    end

    vim.fn.jobstart({ "gtkwave", file }, { detach = true })

    pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
  end,
})


--require("kanagawa").setup({ transparent = true })
vim.cmd.colorscheme("vague")

vim.api.nvim_set_hl(0, "StatusLine", { fg = "#5a7a6a", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#333333", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineTerm", { fg = "#5a7a6a", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineTermNC", { fg = "#333333", bg = "NONE" })

vim.api.nvim_set_hl(0, "MsgArea", { fg = "#997db1" })
vim.api.nvim_set_hl(0, "ModeMsg", { fg = "#997db1" })
vim.api.nvim_set_hl(0, "CmdLine", { fg = "#997db1" })
