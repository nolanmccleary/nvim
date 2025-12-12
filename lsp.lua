
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


vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
vim.lsp.enable('svls')
