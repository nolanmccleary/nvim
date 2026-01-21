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
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.g.mapleader = " "
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.smoothscroll = true
vim.opt.scrolloff = 8
vim.opt.smarttab = true
vim.opt.shiftround = true

-- ===== plugins =====
require("lazy").setup({
  -- Install missing plugins automatically on startup
  install = { missing = true },

  spec = {
    {
      "nvim-tree/nvim-tree.lua",
      lazy=false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      --keys = {
        --{ "<C-n>", "<cmd>NvimTreeToggle | setlocal relativenumber <cr>", silent = true },
      --},
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
                highlight_opened_files = "none",
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
            vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, {desc = "Reset hunk" }) 
            vim.keymap.set("n", "<leader>gd", function()
                require("gitsigns").diffthis() 
                --vim.cmd("wincmd h")
            end, { desc = "Git diff this" })

            vim.keymap.set("n", "]h", function()
                    require("gitsigns").nav_hunk("next")
            end)

            vim.keymap.set("n", "[h", function()
                    require("gitsigns").nav_hunk("prev")
            end)

    	end
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
    install_dir = vim.fn.stdpath('data') .. '/site',
    highlight = {
        enable = true,
    },
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
vim.keymap.set({ "n", "v" }, "d", '"pd', { noremap = true })
vim.keymap.set({ "n", "v" }, "D", '"pD', { noremap = true })
vim.keymap.set({ "n", "v" }, "c", '"pc', { noremap = true })
vim.keymap.set({ "n", "v" }, "C", '"pC', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"pp', { noremap = true, desc = "Paste from deletion register" })
vim.keymap.set("v", "<leader>r", ":!tac<CR>gv", { desc = "Mirror Lines" })

vim.keymap.set("n", "<leader>n", ":noh<CR>", {silent = true})

vim.keymap.set("n", "[w", function()
    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd h")
    if cur_win == vim.api.nvim_get_current_win() then
        vim.cmd("wincmd b")
    end
end, { desc = "Go to left window (wrap)" })

vim.keymap.set("n", "]w", function()
    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd l")
    if cur_win == vim.api.nvim_get_current_win() then
        vim.cmd("wincmd t")
    end
end, { desc = "Go to right window (wrap)" })


vim.keymap.set("n", "<C-n>", function()
  vim.cmd("NvimTreeToggle")
  vim.defer_fn(function()
    local view = require("nvim-tree.view")
    if view.is_visible() then
      vim.api.nvim_set_current_win(view.get_winnr())
      vim.wo.relativenumber = true
      vim.wo.cursorline = false
    end
  end, 0)
end, { silent = true })


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

vim.api.nvim_create_autocmd("BufEnter", { callback = function ()
    update_history()
    vim.wo.relativenumber = true
    vim.wo.cursorline = false
    vim.wo.winhighlight = "LineNr:LineNr,LineNrAbove:LineNrAbove,LineNrBelow:LineNrBelow"
end})
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




_G.last_motion = nil

do
  local pending_count = ""
  local pending_g = false

  local function is_digit(k)
    return k:match("^%d$") ~= nil
  end

  local simple_motions = {
    h=true, j=true, k=true, l=true,
    w=true, b=true, e=true,
    ["0"]=true, ["^"]=true, ["$"]=true,
    G=true,
  }

  vim.on_key(function(key)
    if key == "" or key:sub(1,1) == "<" then
      return
    end

    if is_digit(key) then
      if pending_count == "" and key == "0" then
        _G.last_motion = "0"
      else
        pending_count = pending_count .. key
      end
      pending_g = false
      return
    end

    if pending_g then
      if key == "g" then
        _G.last_motion = (pending_count ~= "" and pending_count or "") .. "gg"
      elseif key == "e" then
        _G.last_motion = (pending_count ~= "" and pending_count or "") .. "ge"
      end
      pending_count = ""
      pending_g = false
      return
    end

    if key == "g" then
      pending_g = true
      return
    end

    if simple_motions[key] then
    local store_key = key

    if key == "j" then store_key = "k" end
    if key == "k" then store_key = "j" end

    _G.last_motion = (pending_count ~= "" and pending_count or "") .. store_key
    pending_count = ""
    return
    end

    pending_count = ""
  end, vim.api.nvim_create_namespace("last_motion_tracker"))
end

vim.keymap.set("n", "m", function()
  if _G.last_motion then
    vim.cmd("normal " .. _G.last_motion)
  else
    vim.notify("No last motion yet", vim.log.levels.INFO)
  end
end, { noremap = true, silent = true, desc = "Repeat last motion" })






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


vim.api.nvim_create_autocmd('FileType', {
    pattern = 'pdf',
    callback = function (args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        vim.fn.jobstart({ 'zathura', file}, { detach = true })
        vim.api.nvim_buf_delete(args.buf, { force = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang then
      pcall(vim.treesitter.start)
    end
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

vim.api.nvim_create_user_command('Gd', function(opts)
    local target_file = opts.args
    if vim.fn.filereadable(target_file) == 0 then
        vim.notify("File not found: " .. target_file, vim.log.levels.ERROR)
        return
    end

    vim.cmd("edit " .. target_file)

    local gs = require('gitsigns')
    local function try_diff()
        local bufnr = vim.api.nvim_get_current_buf()
        gs.attach(bufnr)
        vim.defer_fn(function()
            gs.diffthis()
        end, 100)
    end

    try_diff()
end, {
    nargs = 1,
    complete = 'file',
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

vim.api.nvim_set_hl(0, "LineNr", { fg = "#88b0b0" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#997db1" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#997db1" })

--vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#88b0b0", bold = true })

vim.api.nvim_set_hl(0, "ActiveLineNr", { fg = "#997db1", bold = true })
vim.api.nvim_set_hl(0, "InactiveLineNr", { fg = "#444444" })


vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if vim.api.nvim_get_mode().mode == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end
        vim.wo.winhighlight = "LineNr:InactiveLineNr,LineNrAbove:InactiveLineNr,LineNrBelow:InactiveLineNr"
    end,
})


vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
        vim.wo.relativenumber = true
        vim.wo.cursorline = false
        vim.wo.winhighlight = "LineNr:LineNr,LineNrAbove:LineNrAbove,LineNrBelow:LineNrBelow"
  end,
})

vim.api.nvim_create_autocmd("WinNew", {
  callback = function()
        vim.wo.relativenumber = true
        vim.wo.cursorline = false
        vim.wo.winhighlight = "LineNr:LineNr,LineNrAbove:LineNrAbove,LineNrBelow:LineNrBelow"
  end,
})

vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#88b0b0", bold = true })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#88b0b0" })
vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#88b0b0" })

vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = "#997db1", italic = true, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#997db1", italic = true, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = "#997db1" })
