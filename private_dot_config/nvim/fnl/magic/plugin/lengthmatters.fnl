(module magic.plugin.lengthmatters
  {autoload {nvim aniseed.nvim}})

(set nvim.g.lengthmatters_exluded
     ["unite" "tagbar" "startify" "gundo"
      "vimshell" "w3m" "nerdtree" "help" "qf" "dirvish" "markdown"
      "tex" "conjure-log-[0-9]\\+\\.cljc"])
