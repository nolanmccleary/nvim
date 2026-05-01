return {
  {
    "nvim-telescope/telescope.nvim",
    lazy         = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope    = require("telescope")
      local builtin      = require("telescope.builtin")
      local actions      = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function open_vsplit_dir(prompt_bufnr, dir)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not entry then return end

        local path = entry.path or entry.filename or (entry.value and tostring(entry.value))
        if not path or path == "" then return end

        local old = vim.o.splitright
        vim.o.splitright = (dir == "right")
        vim.cmd("vsplit " .. vim.fn.fnameescape(path))
        vim.o.splitright = old
      end

      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case",
          },
          mappings = {
            i = {
              ["<C-l>"] = function(buf) open_vsplit_dir(buf, "right") end,
              ["<C-k>"] = function(buf) open_vsplit_dir(buf, "left") end,
            },
            n = {
              ["<C-l>"] = function(buf) open_vsplit_dir(buf, "right") end,
              ["<C-k>"] = function(buf) open_vsplit_dir(buf, "left") end,
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })

      vim.keymap.set("n", "<leader>fj", function()
        builtin.find_files({ hidden = true, no_ignore = true, follow = true })
      end, { desc = "Find files (ALL incl ignored)" })

      vim.keymap.set("n", "<leader>fk", function()
        builtin.live_grep({ additional_args = function() return { "--hidden", "--no-ignore" } end })
      end, { desc = "Live grep (ALL incl ignored)" })
    end,
  },
}
