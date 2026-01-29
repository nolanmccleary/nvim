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
--    {
--        "nvim-tree/nvim-tree.lua",
--        lazy=false,
--        dependencies = { "nvim-tree/nvim-web-devicons" },
--        --keys = {
--            --{ "<C-n>", "<cmd>NvimTreeToggle | setlocal relativenumber <cr>", silent = true },
--        --},
--      
--        config = function()
--        local function ovrd_on_attach(bufnr)
--            local api = require("nvim-tree.api")
--
--            local function opts(desc)
--            return {
--                desc = "nvim-tree: " .. desc,
--                buffer = bufnr,
--                noremap = true,
--                silent = true,
--                nowait = true,
--            }
--            end
--
--            api.config.mappings.default_on_attach(bufnr)
--
--            -- ===== 1) AUTO-RESIZE TREE TO FIT LONGEST VISIBLE LINE =====
--            local resize_pending = false
--
--            local function compute_needed_width()
--            local view = require("nvim-tree.view")
--            if not view.is_visible() then return nil end
--
--            local wnr = view.get_winnr()
--            if not wnr then return nil end
--
--            local tree_buf = vim.api.nvim_win_get_buf(wnr)
--            if not vim.api.nvim_buf_is_valid(tree_buf) then return nil end
--
--            local lines = vim.api.nvim_buf_get_lines(tree_buf, 0, -1, false)
--
--            local maxw = 0
--            for _, line in ipairs(lines) do
--                local w = vim.fn.strdisplaywidth(line)
--                if w > maxw then maxw = w end
--            end
--
--            -- padding so the last character isn't right on the edge
--            maxw = maxw + 2
--
--            -- min + max clamp (max = % of screen so it doesn't eat your editor)
--            local minw = 30
--            local maxw_cap = math.floor(vim.o.columns * 0.70)
--
--            if maxw < minw then maxw = minw end
--            if maxw > maxw_cap then maxw = maxw_cap end
--
--            return maxw
--            end
--
--            local function resize_tree()
--            local target = compute_needed_width()
--            if not target then return end
--            pcall(api.tree.resize, { width = target })
--            end
--
--            local function schedule_resize()
--            if resize_pending then return end
--            resize_pending = true
--            vim.defer_fn(function()
--                resize_pending = false
--                resize_tree()
--            end, 30)
--            end
--
--            -- Resize when tree opens / cursor moves / view changes
--            vim.api.nvim_create_autocmd(
--            { "BufEnter", "CursorMoved", "VimResized", "WinResized" },
--            { buffer = bufnr, callback = schedule_resize }
--            )
--
--            -- Your existing split open mappings
--            vim.keymap.set("n", "vl", function()
--            vim.opt.splitright = false
--            api.node.open.vertical()
--            schedule_resize()
--            end, opts("Vertical Split Left"))
--
--            vim.keymap.set("n", "vr", function()
--            vim.opt.splitright = true
--            api.node.open.vertical()
--            schedule_resize()
--            end, opts("Vertical Split Right"))
--
--            -- ===== 2) "\" CLOSES THE FOLDER YOU'RE INSIDE =====
--            -- If you're on a file inside an opened folder -> close its parent folder.
--            -- If you're on an opened folder -> close that folder.
--            
--            -- "\" CLOSES THE FOLDER YOU'RE INSIDE (works on new nvim-tree)
--            vim.keymap.set("n", "\\", function()
--                local node = api.tree.get_node_under_cursor()
--                if not node then return end
--
--                -- If cursor is on an OPEN folder -> close it
--                if node.type == "directory" and node.open then
--                    api.node.open.edit() -- toggles folder open/close
--                else
--                    -- If cursor is on a file (or anything inside a folder) -> close the parent folder
--                    api.node.navigate.parent_close()
--                end
--
--                schedule_resize()
--            end, opts("Close folder you're inside"))
--
--            -- One resize right after attach
--            schedule_resize()
--        end
--
--        require("nvim-tree").setup({
--            on_attach = ovrd_on_attach,
--            
--            sync_root_with_cwd = true,
--            respect_buf_cwd = true,
--            update_focused_file = {
--            enable = true,
--            update_root = true,
--            },
--            view = {
--            adaptive_size = true, -- lets nvim-tree resize itself instead of fixed width
--            -- You can still set a minimum width:
--            width = { min = 30 },
--            },
--
--            renderer = {
--            highlight_opened_files = "none",
--            icons = {
--                show = { file = true, folder = true, folder_arrow = true, git = true },
--            },
--            },
--
--            git = { enable = true, ignore = false },
--        })
--        end,
--    
--
--
--
--
--
--    },
--

    
        {
            "stevearc/oil.nvim",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                local oil = require("oil")

                -- ---- Sidebar handling ----
                local oil_sidebar_win = nil

                local function is_valid_win(win)
                return win and vim.api.nvim_win_is_valid(win)
                end

                local function is_oil_win(win)
                if not is_valid_win(win) then return false end
                local buf = vim.api.nvim_win_get_buf(win)
                return vim.bo[buf].filetype == "oil"
                end

                local function open_oil_sidebar(dir)
                dir = dir or vim.fn.getcwd()

                if is_oil_win(oil_sidebar_win) then
                    vim.api.nvim_set_current_win(oil_sidebar_win)
                    oil.open(dir)
                    return
                end

                vim.cmd("topleft vsplit")
                oil_sidebar_win = vim.api.nvim_get_current_win()
                vim.cmd("wincmd H")
                vim.api.nvim_win_set_width(oil_sidebar_win, 35)
                vim.wo.winfixwidth = true

                vim.o.splitright = true
                oil.open(dir)
                end

                local function close_oil_sidebar()
                if is_oil_win(oil_sidebar_win) then
                    pcall(vim.api.nvim_win_close, oil_sidebar_win, true)
                end
                oil_sidebar_win = nil
                end

                local function toggle_oil_sidebar()
                if is_oil_win(oil_sidebar_win) then
                    close_oil_sidebar()
                else
                    
                    local buf = vim.api.nvim_get_current_buf()
                    local name = vim.api.nvim_buf_get_name(buf)

                    local dir
                    if name ~= "" then
                    dir = vim.fn.fnamemodify(name, ":p:h")
                    else
                    dir = vim.fn.getcwd()
                    end

                    open_oil_sidebar(dir)
                end
                end

                -- ---- Window picker (A/B/C/...) ----
                local function pick_target_window()
                local wins = vim.api.nvim_tabpage_list_wins(0)
                local candidates = {}

                for _, w in ipairs(wins) do
                    local buf = vim.api.nvim_win_get_buf(w)
                    local bt = vim.bo[buf].buftype
                    local ft = vim.bo[buf].filetype
                    if bt == "" and ft ~= "oil" then
                    table.insert(candidates, w)
                    end
                end

                table.sort(candidates, function(a, b)
                    local pa = vim.api.nvim_win_get_position(a)
                    local pb = vim.api.nvim_win_get_position(b)
                    if pa[2] == pb[2] then return pa[1] < pb[1] end
                    return pa[2] < pb[2]
                end)

                if #candidates == 0 then
                    vim.notify("No target windows to split into", vim.log.levels.WARN)
                    return nil
                end

                local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                local msg = {}
                for i, w in ipairs(candidates) do
                    local buf = vim.api.nvim_win_get_buf(w)
                    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
                    table.insert(msg, string.format("%s:%s", letters:sub(i,i), name ~= "" and name or "[No Name]"))
                end

                vim.notify("Pick target → " .. table.concat(msg, "  |  "), vim.log.levels.INFO)

                local c = vim.fn.getcharstr():upper()
                local idx = letters:find(c, 1, true)
                if not idx or idx > #candidates then return nil end
                return candidates[idx]
                end

                local function open_entry_on_target(mode) -- "edit", "left", or "right"
                    local entry = oil.get_cursor_entry()
                    local dir = oil.get_current_dir()
                    if not entry or not dir then return end

                    if entry.type == "directory" then
                        oil.select()
                        return
                    end

                    local wins = vim.api.nvim_tabpage_list_wins(0)
                    local candidates = {}

                    for _, w in ipairs(wins) do
                        local buf = vim.api.nvim_win_get_buf(w)
                        local bt = vim.bo[buf].buftype
                        local ft = vim.bo[buf].filetype
                        if bt == "" and ft ~= "oil" then
                            table.insert(candidates, w)
                        end
                    end

                    local target
                    if #candidates == 0 then
                        -- NO WINDOWS CASE: Create a new split to the right of Oil
                        vim.cmd("vsplit")
                        target = vim.api.nvim_get_current_win()
                        -- Ensure we don't accidentally split the sidebar itself
                        vim.api.nvim_win_set_width(oil_sidebar_win, 35) 
                    elseif #candidates == 1 then
                        target = candidates[1]
                    else
                        target = pick_target_window()
                    end

                    if not target then return end

                    vim.api.nvim_set_current_win(target)

                    if mode == "edit" then
                        vim.cmd("edit " .. vim.fn.fnameescape(dir .. entry.name))
                    else
                        local old = vim.o.splitright
                        vim.o.splitright = (mode == "right")
                        vim.cmd("vsplit " .. vim.fn.fnameescape(dir .. entry.name))
                        vim.o.splitright = old
                    end

                    if is_oil_win(oil_sidebar_win) then
                        vim.api.nvim_set_current_win(oil_sidebar_win)
                    end
                end

                -- ---- Modified Oil Setup ----
                oil.setup({
                    default_file_explorer = true,
                    columns = { "icon" },
                    view_options = { show_hidden = false },
                    keymaps = {
                        ["g?"] = "actions.show_help",
                        ["q"]  = "actions.close",
                        ["\\"] = "actions.parent",

                        ["<CR>"] = { 
                            desc = "Open in chosen window", 
                            callback = function() open_entry_on_target("edit") end 
                        },

                        ["<C-k>"] = {
                            desc = "Vsplit LEFT of chosen window",
                            callback = function() open_entry_on_target("left") end,
                        },
                        ["<C-l>"] = {
                            desc = "Vsplit RIGHT of chosen window",
                            callback = function() open_entry_on_target("right") end,
                        },
                    },
                })
                -- Toggle sidebar with <C-n>
                vim.keymap.set("n", "<C-n>", toggle_oil_sidebar, { silent = true, desc = "Toggle Oil sidebar (cwd)" })

                -- Keep Oil synced to :cd
                vim.api.nvim_create_autocmd("DirChanged", {
                callback = function()
                    if is_oil_win(oil_sidebar_win) then
                    vim.api.nvim_win_call(oil_sidebar_win, function()
                        oil.open(vim.fn.getcwd())
                    end)
                    end
                end,
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


local function global_find_forward()
  local c = vim.fn.getcharstr()
  if c == "" then return end

  local pat = "\\V" .. vim.fn.escape(c, "\\")
  local n = vim.v.count1

  for _ = 1, n do
    vim.fn.search(pat, "W")
  end
end

local function global_find_backward()
  local c = vim.fn.getcharstr()
  if c == "" then return end

  local pat = "\\V" .. vim.fn.escape(c, "\\")
  local n = vim.v.count1

  for _ = 1, n do
    vim.fn.search(pat, "bW")
  end
end

vim.keymap.set("n", "f", global_find_forward,  { noremap = true, silent = true })
vim.keymap.set("n", "F", global_find_backward, { noremap = true, silent = true })


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

vim.keymap.set("n", "\\", function()
  if _G.last_motion then
    vim.cmd("normal " .. _G.last_motion)
  else
    vim.notify("No last motion yet", vim.log.levels.INFO)
  end
end, { noremap = true, silent = true, desc = "Repeat last motion" })

vim.keymap.set("v", "\\", function()
  if _G.last_motion then
    vim.cmd("normal " .. _G.last_motion)
  else
    vim.notify("No last motion yet", vim.log.levels.INFO)
  end
end, { noremap = true, silent = true, desc = "Repeat last motion" })





local last_char = nil
local last_dir = 1 -- 1 = forward, -1 = backward

local function global_find(dir)
  local c = vim.fn.getcharstr()
  if c == "" then return end

  last_char = c
  last_dir = dir

  local pat = "\\V" .. vim.fn.escape(c, "\\")
  local flags = (dir == 1) and "W" or "bW"

  for _ = 1, vim.v.count1 do
    vim.fn.search(pat, flags)
  end
end

vim.keymap.set("n", "f", function() global_find(1) end,  { noremap = true, silent = true })
vim.keymap.set("n", "F", function() global_find(-1) end, { noremap = true, silent = true })

vim.keymap.set("n", ";", function()
  if not last_char then return end
  local pat = "\\V" .. vim.fn.escape(last_char, "\\")
  local flags = (last_dir == 1) and "W" or "bW"
  vim.fn.search(pat, flags)
end, { noremap = true, silent = true })

vim.keymap.set("n", ",", function()
  if not last_char then return end
  local pat = "\\V" .. vim.fn.escape(last_char, "\\")
  local flags = (last_dir == 1) and "bW" or "W"
  vim.fn.search(pat, flags)
end, { noremap = true, silent = true })




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
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          -- IMPORTANT: no "--no-ignore", no "--hidden"
        },
      },
      pickers = {
        find_files = {
          hidden = false,   -- normal find_files
          no_ignore = false -- respects .gitignore
        },
      },
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


local function get_file_age()
    local file_path = vim.api.nvim_buf_get_name(0)
    if file_path == "" then return "New File" end

    local stats = vim.uv.fs_stat(file_path)
    if not stats then return "Unknown" end

    local mtime = stats.mtime.sec
    local now = os.time()
    local diff = now - mtime

    -- Convert seconds into a human-readable format
    if diff < 60 then return diff .. "s ago"
    elseif diff < 3600 then return math.floor(diff / 60) .. "m ago"
    elseif diff < 86400 then return math.floor(diff / 3600) .. "h ago"
    else return math.floor(diff / 86400) .. "d ago"
    end
end

-- Example usage: Print age to the command line
vim.keymap.set('n', '<leader>a', function()
    print("File modified: " .. get_file_age())
end, { desc = "Check file age" })




local builtin = require("telescope.builtin")

-- Normal (respects .gitignore)
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (gitignore)" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep (gitignore)" })

-- "J" and "K" variants (include ignored + hidden)
vim.keymap.set("n", "<leader>fj", function()
  builtin.find_files({
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end, { desc = "Find files (ALL incl ignored)" })

vim.keymap.set("n", "<leader>fk", function()
  builtin.live_grep({
    additional_args = function()
      return { "--hidden", "--no-ignore" }
    end,
  })
end, { desc = "Live grep (ALL incl ignored)" })


local function smart_edge_resize(dir)
  local cur = vim.api.nvim_get_current_win()

  local function win_exists(cmd)
    vim.cmd(cmd)
    local moved = vim.api.nvim_get_current_win() ~= cur
    vim.api.nvim_set_current_win(cur)
    return moved
  end

  local delta = 5

  if dir == "left" then
    if win_exists("wincmd h") then
      vim.cmd("wincmd h")
      vim.cmd("vertical resize -" .. delta)
      vim.api.nvim_set_current_win(cur)
    else
      vim.cmd("vertical resize +" .. delta)
    end
  else
    if win_exists("wincmd h") then
      vim.cmd("wincmd h")
      vim.cmd("vertical resize +" .. delta)
      vim.api.nvim_set_current_win(cur)
    else
      vim.cmd("vertical resize -" .. delta)
    end
  end
end


vim.keymap.set("n", "<C-]>", function()
  if vim.bo.filetype ~= "oil" then
    smart_edge_resize("right")
  end
end, { silent = true })

vim.keymap.set("n", "<C-[>", function()
  if vim.bo.filetype ~= "oil" then
    smart_edge_resize("left")
  end
end, { silent = true })

