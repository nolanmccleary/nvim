return {
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
      -- Render vim.notify messages as corner popups instead of cmdline
      -- echoes, so multi-line LSP warnings never block on hit-enter.
      -- History is kept in :Fidget history (and :messages).
      notification = {
        override_vim_notify = true,
      },
    },
  },
}
