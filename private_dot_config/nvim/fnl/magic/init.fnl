(module magic.init
  {autoload       {a      aniseed.core
                   nvim   aniseed.nvim
                   utils  magic.utils
                   lsp    lspconfig
                   meta      magic.meta}
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
(set nvim.o.sessionoptions "blank,curdir,folds,help,tabpages,winsize")
(set nvim.o.inccommand :split)
(set nvim.o.completeopt "menu")
(nvim.ex.set :list :number)


;; Packer configuration format: https://github.com/wbthomason/packer.nvim
(utils.use
  ;; Config for packer startup function
  {:git
   {:default_url_format "https://hub.fastgit.org/%s"}}

  ;; MagicKit
  :wbthomason/packer.nvim {}
  :Olical/aniseed {}

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
  :tpope/vim-repeat {}

  ;; Tools
  :Olical/conjure {}
  :airblade/vim-gitgutter {}
  :nvim-telescope/telescope.nvim
    {:requires [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]}
  :lazytanuki/nvim-mapper {:requires [:nvim-telescope/telescope.nvim]}
  :Shougo/deoplete.nvim {:run ":UpdateRemotePlugins"}
  :deoplete-plugins/deoplete-lsp {:requires [:Shougo/deoplete.nvim]}
  :dense-analysis/ale {}
  :neovim/nvim-lspconfig {}
  :nvim-telescope/telescope-frecency.nvim
    {:requires [:nvim-telescope/telescope.nvim :tami5/sql.nvim]}
  ;;:glepnir/lspsaga.nvim {}
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"}

  ;; Langs
  ;;:hellerve/carp-vim {}
  :bakpakin/fennel.vim {}
  ;;:bfrg/vim-cpp-modern {}
  :tweekmonster/deoplete-clang2 {:requires [:Shougo/deoplete.nvim]}
  ;;:wlangstroth/vim-racket {}
  ;;:hylang/vim-hy {}
  )


;;; Specific Configurations

;; Linter

(set nvim.g.ale_lint_on_text_changed true)
(set nvim.g.ale_fixers {:* [:remove_trailing_lines :trim_whitespace] })
(set nvim.g.ale_fix_on_save true)
(set nvim.g.ale_pattern_options {
   "conjure-log-[0-9]\\+\\.cljc"
     {:ale_linters {}
      :ale_fixers {}}})


;; Interactive Development

(set nvim.g.conjure#log#hud#width 1)
(set nvim.g.conjure#log#hud#anchor :SE)
(set nvim.g.conjure#log#hud#border :none)
; Enable enable aniseed as fennel environment
(set nvim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")


;; Auto Complete

(global auto_pair_lisp (fn []
  (let [auto-pairs nvim.g.AutoPairs]
    (tset auto-pairs "'" nil)
    (tset auto-pairs "`" nil)
    (set nvim.b.AutoPairs auto-pairs))))

(augroup auto-pair-config
  (nvim.ex.autocmd
    :FileType meta.lisp-file-types
    "call v:lua.auto_pair_lisp()"))

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


;; Telescope

(require :magic.telescope)


;; LSP

(let [servers [:clangd :clojure_lsp]]
  (each [_ s (ipairs servers)]
    ((-> lsp (. s) (. "setup")) {})))
;; (tset vim.lsp.handlers
;;       :textDocument/publishDiagnostics
;;       (vim.lsp.with
;;         vim.lsp.diagnostic.on_publish_diagnostics
;;         {:virtual_text false}))


;; Treesitter

(require :magic.treesitter)


;; Editing utils

(set nvim.g.sexp_filetypes meta.lisp-file-types)


;; Mappings

(require :magic.mappings)
