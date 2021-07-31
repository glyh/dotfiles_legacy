(module magic.init
  {autoload       {nvim   aniseed.nvim
                   u      magic.utils
                   lsp    lspconfig
                   mapper nvim-mapper
                   teleb  telescope.builtin}
   require-macros [magic.macros]})


;;; Introduction

;; Aniseed compiles this (and all other Fennel files under fnl) into the lua
;; directory. The init.lua file is configured to load this file when ready.

;; We'll use modules, macros and functions to define our configuration and
;; required plugins. We can use Aniseed to evaluate code as we edit it or just
;; restart Neovim.

;; You can learn all about Conjure and how to evaluate things by executing
;; :ConjureSchool in your Neovim. This will launch an interactive tutorial.



;;; Generic configuration

(set nvim.o.termguicolors true)
(set nvim.o.mouse "a")
(set nvim.o.updatetime 500)
(set nvim.o.timeoutlen 500)
;;(set nvim.o.sessionoptions ["blank" "curdir" "folds" "help" "tabpages" "winsize"])
(set nvim.o.sessionoptions "blank,curdir,folds,help,tabpages,winsize")
(set nvim.o.inccommand :split)
(set nvim.o.completeopt "menu")
(nvim.ex.set :list :number)

;; Packer configuration format: https://github.com/wbthomason/packer.nvim
(u.use
  ;; Config for packer startup function
  {:git
   {:default_url_format "https://hub.fastgit.org/%s"}}

  ;; MagicKit
  :Olical/aniseed {}
  :Olical/conjure {}
  :wbthomason/packer.nvim {}

  ;; UI
  :itchyny/lightline.vim {}
  :cocopon/iceberg.vim {}
  :ncm2/float-preview.nvim {}
  :whatyouhide/vim-lengthmatters {}

  ;; Editing
  :tpope/vim-surround {}
  :wellle/targets.vim {}
  :jiangmiao/auto-pairs {}
  :easymotion/vim-easymotion {}
  :guns/vim-sexp {}
  :tpope/vim-sexp-mappings-for-regular-people {:requires [:guns/vim-sexp]}
  :tpope/vim-commentary {}
  :tpope/vim-sleuth {}

  ;; Tools
  :airblade/vim-gitgutter {}
  :nvim-telescope/telescope.nvim
    {:requires [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]}
  :lazytanuki/nvim-mapper {:requires [:nvim-telescope/telescope.nvim]}
  :Shougo/deoplete.nvim {:run ":UpdateRemotePlugins"}
  :deoplete-plugins/deoplete-lsp {:requires [:Shougo/deoplete.nvim]}
  :dense-analysis/ale {}
  :neovim/nvim-lspconfig {}

  ;; Langs
  :hellerve/carp-vim {}
  :bakpakin/fennel.vim {}
  :bfrg/vim-cpp-modern {}
  :deoplete-plugins/deoplete-clang {:requires [:Shougo/deoplete.nvim]}
  :wlangstroth/vim-racket {})


;;; Specific Configurations

;; Linter

(set nvim.g.ale_lint_on_text_changed true)
(set nvim.g.ale_fixers {:* [:remove_trailing_lines :trim_whitespace] })
(set nvim.g.ale_fix_on_save true)


;; Interactive Development

(set nvim.g.conjure#log#hud#width 1)
(set nvim.g.conjure#log#hud#anchor :SE)
(set nvim.g.conjure#log#hud#border :none)
(set nvim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")


;; Auto Complete

(defn auto_pair_setup []
  (let [auto-pairs nvim.g.AutoPairs]
    (tset auto-pairs "'" nil)
    (tset auto-pairs "`" nil)
    (set nvim.b.AutoPairs auto-pairs)))
(augroup auto-pairs-config
  (nvim.ex.autocmd
    :FileType "clojure,fennel,scheme"
    (.. "call v:lua.require('" *module-name* "').auto_pair_setup()")))

(set nvim.g.deoplete#enable_at_startup true)
(nvim.fn.deoplete#custom#option :keyword_patterns
  {:clojure "[\\w!$%&*+/:<=>?@\\^_~\\-\\.#]*"})
(set nvim.g.deoplete#sources#clang#libclang_path "/usr/lib/libclang.so")
(set nvim.g.deoplete#sources#clang#clang_header "/usr/include")


;; UI

(nvim.ex.colorscheme :iceberg)

(set nvim.g.lightline {:colorscheme :iceberg})

(set nvim.g.float_preview#docked false)
(set nvim.g.float_preview#max_width 80)
(set nvim.g.float_preview#max_height 40)

(set nvim.g.lengthmatters_exluded
     ["unite" "tagbar" "startify" "gundo"
      "vimshell" "w3m" "nerdtree" "help" "qf" "dirvish" "markdown"
      "tex" "conjure-log-[0-9]\\+\\.cljc"])


;; LSP

(let [servers [:clangd :clojure_lsp]]
  (each [_ s (ipairs servers)]
    ((. (. lsp s) "setup") {})))


;; Mapper & Mappings

(mapper.setup {:no_map true})

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader "\\")
(u.keymaps
  {:i
   {"<TAB>"
    [(fn [] (u.termcode (if (= 1 (nvim.fn.pumvisible)) "<Down>" "<TAB>")))
     {:noremap true :silent true :expr true}
     "Autocomplete" "smart_tab_tab" "Smart tab (Tab)"]

    "<S-TAB>"
    [(fn [] (u.termcode (if (= 1 (nvim.fn.pumvisible)) "<Up>" "<TAB>")))
     {:noremap true :silent true :expr true}
     "Autocomplete" "smart_tab_shift_tab" "Smart tab (Shift-Tab)"]

    "<CR>"
    [(fn [] (u.termcode (if (= 1 (nvim.fn.pumvisible)) "<C-y>" "<C-g>u<CR>")))
     {:noremap true :expr true}
     "Autocomplete" "smart_tab_return" "Smart tab (Enter)"]}


   :n
   {"<leader>ff"
    [teleb.find_files ;;"<cmd>Telescope find_files<CR>"
     {:noremap true}
     "Files" "telescope_find_files" "Find files via Telescope"]
    }})
(comment "<leader>fp"
      ["<cmd>Telescope mapper<CR>"
       {:noremap true}
       "Mappings" "mapper_show_mappings" "Show mappings via Mapper"])

;; (tset _G "shit" teleb.find_files)
;; (nvim.set_keymap :n "<leader>ff" "v:lua.shit()" {:noremap true})
