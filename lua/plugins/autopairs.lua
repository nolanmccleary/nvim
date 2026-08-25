return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true, -- treesitter-aware: don't pair inside strings/comments
      })

      -- Insert `()` after confirming a function/method completion from cmp.
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done()
        )
      end
    end,
  },
}
