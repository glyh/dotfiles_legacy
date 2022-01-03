return function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- WARN: Copied from hrsh7th/cmp-nvim-lsp, may be updated later
  local completionItem = capabilities.textDocument.completion.completionItem
  completionItem.snippetSupport = true
  completionItem.preselectSupport = true
  completionItem.insertReplaceSupport = true
  completionItem.labelDetailsSupport = true
  completionItem.deprecatedSupport = true
  completionItem.commitCharactersSupport = true
  completionItem.tagSupport = { valueSet = { 1 } }
  completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }

  local lspconfig = require('lspconfig')
  -- local lsputil = require('lspconfig.util')

  lspconfig.clangd.setup{ capabilities = capabilities }

  lspconfig.rust_analyzer.setup{ capabilities = capabilities }

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  lspconfig.sumneko_lua.setup {
    cmd = {'lua-language-server'},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
    capabilities = capabilities
  }

  lspconfig.nimls.setup { capabilities = capabilities }
  lspconfig.pyright.setup { capabilities = capabilities }

  -- lspconfig.efm.setup(require('plugins.efm'))
end
