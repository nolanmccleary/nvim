vim.keymap.set({ "n", "v" }, "j", "k", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "j", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>y", ":%y<CR>", { silent = true, desc = "Copy entire file to clipboard" })

local function get_file_age()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then return "New File" end

  local stats = vim.uv.fs_stat(file_path)
  if not stats then return "Unknown" end

  local diff = os.time() - stats.mtime.sec
  if diff < 60    then return diff                      .. "s ago"
  elseif diff < 3600  then return math.floor(diff / 60)   .. "m ago"
  elseif diff < 86400 then return math.floor(diff / 3600) .. "h ago"
  else                      return math.floor(diff / 86400) .. "d ago"
  end
end

vim.keymap.set("n", "<leader>a", function()
  print("File modified: " .. get_file_age())
end, { desc = "Check file age" })

vim.keymap.set("n", "[b",        ":bprevious<CR>",     { silent = true })
vim.keymap.set("n", "]b",        ":bnext<CR>",         { silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>",      { silent = true })

vim.keymap.set("n", "<leader>vst", ":vsplit | term<CR>", { silent = true })
vim.keymap.set("n", "<leader>st",  ":split | term<CR>",  { silent = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- d/c/D/C go to register "p" so yank register is never clobbered
vim.keymap.set({ "n", "v" }, "d",          '"pd',  { noremap = true })
vim.keymap.set({ "n", "v" }, "D",          '"pD',  { noremap = true })
vim.keymap.set({ "n", "v" }, "c",          '"pc',  { noremap = true })
vim.keymap.set({ "n", "v" }, "C",          '"pC',  { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>p",  '"pp',  { noremap = true, desc = "Paste from deletion register" })

vim.keymap.set("v", "<leader>r", ":!tac<CR>gv", { desc = "Mirror Lines" })
vim.keymap.set("n", "<leader>n", ":noh<CR>",     { silent = true })

-- ── Window navigation (wrapping) ──────────────────────────────────────────────

vim.keymap.set("n", "[w", function()
  local cur = vim.api.nvim_get_current_win()
  vim.cmd("wincmd h")
  if cur == vim.api.nvim_get_current_win() then vim.cmd("wincmd b") end
end, { desc = "Go to left window (wrap)" })

vim.keymap.set("n", "]w", function()
  local cur = vim.api.nvim_get_current_win()
  vim.cmd("wincmd l")
  if cur == vim.api.nvim_get_current_win() then vim.cmd("wincmd t") end
end, { desc = "Go to right window (wrap)" })

-- ── Window swap (wrapping) ────────────────────────────────────────────────────

local function is_swappable_win(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.bo[buf].buftype ~= "prompt" and vim.bo[buf].filetype ~= "NvimTree"
end

local function ordered_wins_lr()
  local out = {}
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_swappable_win(w) then table.insert(out, w) end
  end
  table.sort(out, function(a, b)
    local pa = vim.api.nvim_win_get_position(a)
    local pb = vim.api.nvim_win_get_position(b)
    if pa[2] == pb[2] then return pa[1] < pb[1] end
    return pa[2] < pb[2]
  end)
  return out
end

local function swap_with_wrap(dir)
  local curwin = vim.api.nvim_get_current_win()
  local wins   = ordered_wins_lr()

  if #wins < 2 then print("Need at least 2 swappable windows"); return end

  local idx
  for i, w in ipairs(wins) do
    if w == curwin then idx = i; break end
  end
  if not idx then print("Current window is not swappable"); return end

  local nidx     = ((idx - 1 + dir) % #wins) + 1
  local neighwin = wins[nidx]
  if neighwin == curwin then return end

  local curbuf   = vim.api.nvim_win_get_buf(curwin)
  local neighbuf = vim.api.nvim_win_get_buf(neighwin)
  vim.api.nvim_win_set_buf(curwin,   neighbuf)
  vim.api.nvim_win_set_buf(neighwin, curbuf)
end

vim.keymap.set("n", "[s", function() swap_with_wrap(-1) end, { desc = "Swap with left window (wrap)" })
vim.keymap.set("n", "]s", function() swap_with_wrap( 1) end, { desc = "Swap with right window (wrap)" })

-- ── Window resize (smart, edge-aware) ────────────────────────────────────────

local function smart_edge_resize(dir)
  local cur   = vim.api.nvim_get_current_win()
  local delta = 5

  local function has_left_neighbor()
    vim.cmd("wincmd h")
    local moved = vim.api.nvim_get_current_win() ~= cur
    vim.api.nvim_set_current_win(cur)
    return moved
  end

  local sign = (dir == "left") and "-" or "+"
  if has_left_neighbor() then
    vim.cmd("wincmd h")
    vim.cmd("vertical resize " .. sign .. delta)
    vim.api.nvim_set_current_win(cur)
  else
    vim.cmd("vertical resize " .. sign .. delta)
  end
end

vim.keymap.set("n", "<C-l>", function()
  if vim.bo.filetype ~= "oil" then smart_edge_resize("right") end
end, { silent = true })

vim.keymap.set("n", "<C-k>", function()
  if vim.bo.filetype ~= "oil" then smart_edge_resize("left") end
end, { silent = true })

-- ── Per-window buffer history ─────────────────────────────────────────────────

local history = {}

local function update_history()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo.buftype ~= "" or vim.bo.filetype == "NvimTree" then return end

  if not history[win] then
    history[win] = { index = 1, list = { buf } }
    return
  end

  local h = history[win]
  if h.list[h.index] == buf then return end

  while #h.list > h.index do table.remove(h.list) end
  table.insert(h.list, buf)
  h.index = #h.list
end

local function cleanup_history(args)
  for _, h in pairs(history) do
    for i = #h.list, 1, -1 do
      if h.list[i] == args.buf then
        table.remove(h.list, i)
        if h.index >= i and h.index > 1 then h.index = h.index - 1 end
      end
    end
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  callback = function() vim.schedule(update_history) end,
})
vim.api.nvim_create_autocmd("BufDelete", { callback = cleanup_history })

local function navigate_local_history(delta)
  local h = history[vim.api.nvim_get_current_win()]
  if not h or #h.list == 0 then print("No local history for this window"); return end

  local new_index = h.index + delta
  if new_index >= 1 and new_index <= #h.list then
    h.index = new_index
    local buf = h.list[new_index]
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_set_current_buf(buf) end
  else
    print(delta > 0 and "At newest jump" or "At oldest jump")
  end
end

vim.keymap.set("n", "[c", function() navigate_local_history(-1) end, { desc = "Local Back" })
vim.keymap.set("n", "]c", function() navigate_local_history( 1) end, { desc = "Local Forward" })

-- ── Repeat last motion ────────────────────────────────────────────────────────

_G.last_motion = nil

do
  local pending_count = ""
  local pending_g     = false

  local simple_motions = {
    h=true, j=true, k=true, l=true,
    w=true, b=true, e=true,
    ["0"]=true, ["^"]=true, ["$"]=true,
    G=true,
  }

  vim.on_key(function(key)
    if key == "" or key:sub(1, 1) == "<" then return end

    if key:match("^%d$") then
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
      pending_g     = false
      return
    end

    if key == "g" then pending_g = true; return end

    if simple_motions[key] then
      local store_key = key
      if key == "j" then store_key = "k" end
      if key == "k" then store_key = "j" end
      _G.last_motion = (pending_count ~= "" and pending_count or "") .. store_key
      pending_count  = ""
      return
    end

    pending_count = ""
  end, vim.api.nvim_create_namespace("last_motion_tracker"))
end

local function repeat_last_motion()
  if _G.last_motion then
    vim.cmd("normal " .. _G.last_motion)
  else
    vim.notify("No last motion yet", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "\\", repeat_last_motion, { noremap = true, silent = true, desc = "Repeat last motion" })
vim.keymap.set("v", "\\", repeat_last_motion, { noremap = true, silent = true, desc = "Repeat last motion" })

-- ── ; / , character search repeat ────────────────────────────────────────────

vim.keymap.set("n", ";", function()
  if not last_char then return end -- luacheck: ignore
  vim.fn.search("\\V" .. vim.fn.escape(last_char, "\\"), (last_dir == 1) and "W" or "bW") -- luacheck: ignore
end, { noremap = true, silent = true })

vim.keymap.set("n", ",", function()
  if not last_char then return end -- luacheck: ignore
  vim.fn.search("\\V" .. vim.fn.escape(last_char, "\\"), (last_dir == 1) and "bW" or "W") -- luacheck: ignore
end, { noremap = true, silent = true })
