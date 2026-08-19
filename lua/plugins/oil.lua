return {
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    config = true,
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "malewicz1337/oil-git.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = {
          show_file_highlights      = true,
          show_directory_highlights = true,
          show_file_symbols         = true,
          show_directory_symbols    = true,
          symbol_position           = "eol",
        },
      },
    },
    config = function()
      local oil = require("oil")

      local oil_sidebar_win = nil

      local function is_valid_win(win)
        return win and vim.api.nvim_win_is_valid(win)
      end

      local function is_oil_win(win)
        if not is_valid_win(win) then return false end
        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "oil"
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
        vim.o.splitright   = true
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
          return
        end

        local buf  = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(buf)
        local dir

        if vim.bo[buf].buftype ~= "" or name == "" or name:match("^term://") then
          dir = vim.fn.getcwd()
        else
          dir = vim.fn.fnamemodify(name, ":p:h")
        end

        open_oil_sidebar(dir)
      end

      local function pick_target_window()
        local candidates = {}

        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "oil" then
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
          local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)), ":t")
          table.insert(msg, string.format("%s:%s", letters:sub(i, i), name ~= "" and name or "[No Name]"))
        end

        vim.notify("Pick target → " .. table.concat(msg, "  |  "), vim.log.levels.INFO)

        local c   = vim.fn.getcharstr():upper()
        local idx = letters:find(c, 1, true)
        if not idx or idx > #candidates then return nil end
        return candidates[idx]
      end

      local function open_entry_on_target(mode) -- "edit", "left", or "right"
        local entry = oil.get_cursor_entry()
        local dir   = oil.get_current_dir()
        if not entry or not dir then return end

        if entry.type == "directory" then
          oil.select()
          return
        end

        -- Prefer real file windows, but fall back to any non-oil window
        -- (e.g. the "nofile" scratch buffer left behind after opening a PNG
        -- externally) so we reuse it instead of cloning the sidebar.
        local normal, any = {}, {}
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if not is_oil_win(w) then
            table.insert(any, w)
            if vim.bo[vim.api.nvim_win_get_buf(w)].buftype == "" then
              table.insert(normal, w)
            end
          end
        end
        local candidates = (#normal > 0) and normal or any

        local target
        if #candidates == 0 then
          -- Oil is the only window: open a real editing area on the far right
          -- rather than vsplitting (which would clone the oil sidebar).
          vim.cmd("botright vsplit")
          target = vim.api.nvim_get_current_win()
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

      oil.setup({
        default_file_explorer = true,
        watch_for_changes = true,
        columns     = { "icon" },
        win_options = { signcolumn = "yes:2" },
        view_options = { show_hidden = false },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["q"]  = "actions.close",
          ["\\"] = "actions.parent",
          ["<CR>"] = {
            desc     = "Open in chosen window",
            callback = function() open_entry_on_target("edit") end,
          },
          ["<C-k>"] = {
            desc     = "Vsplit LEFT of chosen window",
            callback = function() open_entry_on_target("left") end,
          },
          ["<C-l>"] = {
            desc     = "Vsplit RIGHT of chosen window",
            callback = function() open_entry_on_target("right") end,
          },
        },
      })

      vim.keymap.set("n", "<C-n>", toggle_oil_sidebar, { silent = true, desc = "Toggle Oil sidebar (cwd)" })

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
}
