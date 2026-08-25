return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup({
        current_line_blame = false,
        signcolumn         = true,
        numhl              = false,
        linehl             = false,
      })

      local gs = require("gitsigns")

      -- ── Make hunk actions work from either pane of a diff ────────────────
      -- gitsigns only attaches to the real file buffer, so hunk nav/reset are
      -- dead in the LHS (base) pane, whose buffer is a `gitsigns://` scratch.
      -- These helpers route the action to the paired working pane.

      local function is_base_buf(buf)
        return vim.api.nvim_buf_get_name(buf):match("^gitsigns://") ~= nil
      end

      -- The working (RHS) window paired with a base pane: the other diff-mode
      -- window in this tabpage backed by a real, gitsigns-attached file.
      local function paired_work_win()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.wo[win].diff then
            local b = vim.api.nvim_win_get_buf(win)
            if not is_base_buf(b) and vim.bo[b].buftype == "" then
              return win
            end
          end
        end
      end

      -- Move `to`'s cursor onto the line visually aligned with `from`'s cursor.
      -- Diff mode keeps corresponding lines on the same screen row (inserting
      -- filler where needed), so matching screen rows maps across the panes
      -- correctly even when line numbers diverge.
      local function align_cursor(from, to)
        local target = vim.api.nvim_win_call(from, vim.fn.winline)
        local top    = vim.api.nvim_win_call(to, function() return vim.fn.line("w0") end)
        local bot    = vim.api.nvim_win_call(to, function() return vim.fn.line("w$") end)
        local best, best_d
        for l = top, bot do
          local r = vim.fn.screenpos(to, l, 1).row
          if r ~= 0 then
            local d = math.abs(r - target)
            if not best or d < best_d then best, best_d = l, d end
          end
        end
        if best then vim.api.nvim_win_set_cursor(to, { best, 0 }) end
      end

      -- Run a gitsigns action from either pane. From the RHS it behaves
      -- natively; from the LHS it syncs the working pane's cursor to what you
      -- see, runs there, then (via the async callback) restores your focus.
      -- `after` runs in the completion callback with the work window.
      local function diff_aware(run, after)
        return function()
          local cur = vim.api.nvim_get_current_win()
          if not is_base_buf(vim.api.nvim_win_get_buf(cur)) then
            run(nil)
            return
          end
          local work = paired_work_win()
          if not work then return end
          align_cursor(cur, work)
          vim.api.nvim_set_current_win(work)
          run(function()
            vim.schedule(function()
              if after and vim.api.nvim_win_is_valid(work) then after(work, cur) end
              if vim.api.nvim_win_is_valid(cur) then
                vim.api.nvim_set_current_win(cur)
              end
            end)
          end)
        end
      end

      local function nav(direction)
        return diff_aware(
          function(cb) gs.nav_hunk(direction, nil, cb) end,
          function(work, base)
            -- mirror the navigated position back into the base pane
            if vim.api.nvim_win_is_valid(base) then align_cursor(work, base) end
          end
        )
      end

      local reset_hunk = diff_aware(function(cb) gs.reset_hunk(nil, nil, cb) end)

      vim.keymap.set("n", "<leader>gp", gs.preview_hunk,                     { desc = "Git preview hunk" })
      vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame,        { desc = "Git blame toggle" })
      vim.keymap.set("n", "<leader>gr", reset_hunk,                          { desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>gd", function()
        local origin = vim.api.nvim_get_current_win()
        gs.diffthis()
        -- diffthis reads the base from git asynchronously, then opens it in a
        -- new window paired with `origin` (both put into diff mode). Focus that
        -- base window explicitly rather than by direction, so it works in any
        -- split layout. Prefer the gitsigns scratch buffer; fall back to the
        -- other diff-mode window in this tabpage.
        vim.defer_fn(function()
          if not vim.api.nvim_win_is_valid(origin) then return end
          local fallback
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if win ~= origin and vim.wo[win].diff then
              local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
              if name:match("^gitsigns:") then
                vim.api.nvim_set_current_win(win)
                return
              end
              fallback = fallback or win
            end
          end
          if fallback then vim.api.nvim_set_current_win(fallback) end
        end, 50)
      end, { desc = "Git diff this" })
      vim.keymap.set("n", "]h",         nav("next"), { desc = "Next hunk" })
      vim.keymap.set("n", "[h",         nav("prev"), { desc = "Prev hunk" })
    end,
  },
}
