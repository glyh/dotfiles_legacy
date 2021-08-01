(module magic.treesitter
  {autoload       {a             aniseed.core
                   nvim          aniseed.nvim
                   utils         magic.utils
                   treesitter    nvim-treesitter.configs
                   parsers       nvim-treesitter.parsers}
   require-macros [magic.macros]})

;; Set CDN for Github

(defn- fix-cdn [github-original]
  (: github-original :gsub "github.com" "hub.fastgit.org"))

(let [parser-confs (parsers.get_parser_configs)]
  (each [parser _ (pairs parser-confs)]
    (a.update-in parser-confs [parser :install_info :url] fix-cdn)))

;; Set up treesitter

(treesitter.setup
  {:ensure_installed [:fennel :clojure :fish]
   :highlight
     {:enable true
      :additional_vim_regex_highlighting false}})
