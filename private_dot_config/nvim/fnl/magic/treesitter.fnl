(module magic.treesitter
  {autoload       {nvim          aniseed.nvim
                   utils         magic.utils
                   treesitter    nvim-treesitter.configs}
   require-macros [magic.macros]})

(treesitter.setup
  {:ensure_installed [:fennel :clojure :fish]
   :highlight
     {:enable true
      :additional_vim_regex_highlighting false}})
