return {
  {
    "christopher-francisco/tmux-status.nvim",
    lazy = false,
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "christopher-francisco/tmux-status.nvim",
    },
    config = function()
      local tmux_status = require("tmux-status")

      require("lualine").setup({
        options = {
          icons_enabled        = true,
          theme                = "auto",
          component_separators = "",
          section_separators   = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              source = function()
                local gs = vim.b.gitsigns_status_dict
                if not gs then return nil end
                return { added = gs.added, modified = gs.changed, removed = gs.removed }
              end,
            },
          },
          lualine_c = {
            "filename",
            {
              tmux_status.tmux_windows,
              cond    = tmux_status.show,
              padding = { left = 3 },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              tmux_status.tmux_session,
              cond    = tmux_status.show,
              padding = { left = 3 },
            },
          },
        },
      })
    end,
  },
}
