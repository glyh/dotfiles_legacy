(module magic.plugin.lightline
  {autoload {nvim aniseed.nvim
             lsp lspconfig}})

(let [servers [:clangd :clojure_lsp]]
  (each [_ s (ipairs servers)]
    ((. (. lsp s) "setup") {})))
