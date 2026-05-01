-- ── Window focus: line-number dimming + insert-mode escape ───────────────────

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.api.nvim_get_mode().mode == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end
    vim.wo.winhighlight = "LineNr:InactiveLineNr,LineNrAbove:InactiveLineNr,LineNrBelow:InactiveLineNr"
  end,
})

local function restore_line_nr_highlights()
  vim.wo.relativenumber = true
  vim.wo.cursorline     = false
  vim.wo.winhighlight   = "LineNr:LineNr,LineNrAbove:LineNrAbove,LineNrBelow:LineNrBelow"
end

vim.api.nvim_create_autocmd("WinEnter", { callback = restore_line_nr_highlights })
vim.api.nvim_create_autocmd("WinNew",   { callback = restore_line_nr_highlights })

-- ── Treesitter for all supported filetypes ────────────────────────────────────

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang then pcall(vim.treesitter.start) end
  end,
})

-- ── External file viewers ─────────────────────────────────────────────────────

local function open_in_external(executable, buf, file)
  if vim.fn.executable(executable) ~= 1 then
    vim.notify(executable .. " not found in PATH", vim.log.levels.WARN)
    return
  end

  local alt = vim.fn.bufnr("#")
  if alt > 0 and vim.api.nvim_buf_is_valid(alt) then
    vim.cmd("buffer #")
  else
    vim.cmd("enew")
    vim.bo.buftype   = "nofile"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile  = false
  end

  vim.fn.jobstart({ executable, file }, { detach = true })
  pcall(vim.api.nvim_buf_delete, buf, { force = true })
end

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern  = { "*.fst", "*.vcd" },
  callback = function(args) open_in_external("gtkwave", args.buf, args.match) end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern  = { "*.pdf" },
  callback = function(args) open_in_external("zathura", args.buf, args.match) end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern  = { "*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif" },
  callback = function(args) open_in_external("open", args.buf, args.match) end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern  = { "*.mp4", "*.mov", "*.mkv", "*.webm" },
  callback = function(args) open_in_external("open", args.buf, args.match) end,
})

-- ── :Gd <file> — open file and show gitsigns diff ────────────────────────────

vim.api.nvim_create_user_command("Gd", function(opts)
  local target_file = opts.args
  if vim.fn.filereadable(target_file) == 0 then
    vim.notify("File not found: " .. target_file, vim.log.levels.ERROR)
    return
  end

  vim.cmd("edit " .. target_file)

  local gs = require("gitsigns")
  gs.attach(vim.api.nvim_get_current_buf())
  vim.defer_fn(function() gs.diffthis() end, 100)
end, {
  nargs    = 1,
  complete = "file",
})
