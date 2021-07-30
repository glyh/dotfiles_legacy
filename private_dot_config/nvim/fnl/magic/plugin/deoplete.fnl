(module magic.plugin.deoplete
  {autoload {nvim aniseed.nvim}})

(set nvim.g.deoplete#enable_at_startup true)
(nvim.fn.deoplete#custom#option :keyword_patterns
  {:clojure "[\\w!$%&*+/:<=>?@\\^_~\\-\\.#]*"})
(set nvim.g.deoplete#sources#clang#libclang_path "/usr/lib/libclang.so")
(set nvim.g.deoplete#sources#clang#clang_header "/usr/include")
