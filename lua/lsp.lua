-- lua/lsp.lua

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true, noremap = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
  end,
})

local cmp = require('cmp')
cmp.setup({
 
    snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, 
  {
    { name = 'buffer' },
    { name = 'path' },
  })
})

capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('*', {
    capabilities = capabilities,
})


vim.lsp.config("slang-server", {
  cmd = { "/home/nolan/.local/share/nvim/slang-server/build/bin/slang-server" },
  root_markers = { ".git", ".slang" },
  filetypes = {
    "systemverilog",
    "verilog",
  },
})

vim.lsp.enable("slang-server")
vim.lsp.enable('bashls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
