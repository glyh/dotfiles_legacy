return function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }

  local lspconfig = require('lspconfig')
  local lsputil = require('lspconfig.util')

  -- lspconfig.clojure_lsp.setup{
  --     cmd = { 'clojure-lsp' },
  --     filetypes = { 'clojure', 'edn' },
  --     root_dir = lsputil.root_pattern(
  --       'project.clj', 'deps.edn', '.git', 'build.boot'),
  --     capabilities = capabilities
  -- }

  lspconfig.clangd.setup{
    capabilities = capabilities
  }

  lspconfig.rust_analyzer.setup{
    capabilities = capabilities
  }

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

  lspconfig.java_language_server.setup{
    capabilities = capabilities
  }
end
