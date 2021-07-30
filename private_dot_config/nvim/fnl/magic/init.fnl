(module magic.init
  {autoload {plugin magic.plugin
             nvim aniseed.nvim}})

;;; Introduction

;; Aniseed compiles this (and all other Fennel files under fnl) into the lua
;; directory. The init.lua file is configured to load this file when ready.

;; We'll use modules, macros and functions to define our configuration and
;; required plugins. We can use Aniseed to evaluate code as we edit it or just
;; restart Neovim.

;; You can learn all about Conjure and how to evaluate things by executing
;; :ConjureSchool in your Neovim. This will launch an interactive tutorial.


;;; Generic configuration

;;; (set nvim.o.termguicolors true)
(set nvim.o.mouse "a")
(set nvim.o.updatetime 500)
(set nvim.o.timeoutlen 500)
(set nvim.o.sessionoptions "blank,curdir,folds,help,tabpages,winsize")
(set nvim.o.inccommand :split)
(set nvim.o.completeopt "menu")

(nvim.ex.set :list :number)


;;; Mappings

(defn- internal [str]
  (vim.api.nvim_replace_termcodes str true true true))
(defn- keymap [mode from to options]
  "Sets a mapping."
  (nvim.set_keymap mode (internal from) to options))

(global smart_tab (fn [key-either key-or]
  (print key-either key-or)
  (if (nvim.fn.pumvisible) key-either key-or)))

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader "\\")

(nvim.command "inoremap <silent><expr> <S-TAB>  pumvisible() ? \"\\<Up>\" : \"\\<TAB>\"")
(nvim.command "inoremap <silent><expr> <TAB>  pumvisible() ? \"\\<Down\" : \"\\<TAB>\"")
(nvim.command "inoremap <expr> <CR> pumvisible() ? \"\\<C-y>\" : \"\\<C-g>u\\<CR>\"")

;(keymap :i "<S-TAB>" "v:lua.smart_tab(\"\\<Up>\", \"\\<TAB>\")"
;        {:noremap true :silent true :expr true})
;(keymap :i "<TAB>" "v:lua.smart_tab(\"\\<Down>\", \"\\<TAB>\")"
;        {:noremap true :silent true :expr true})
;(keymap :i "<CR>" "v:lua.smart_tab(\"\\<C-y>\", \"\\<C-g>u\\<CR>\")"
;        {:noremap true :expr true})

;;; Plugins

;; Run script/sync.sh to update, install and clean your plugins.
;; Packer configuration format: https://github.com/wbthomason/packer.nvim
(plugin.use
  ;; Config for packer startup function
  {:git
    {:default_url_format "https://hub.fastgit.org/%s"} ;; Use CDN
  }
  ;; Dependencies
  :nvim-lua/popup.nvim {}
  :nvim-lua/plenary.nvim {}

  ;; MagicKit
  :Olical/aniseed {}
  :Olical/conjure {:mod :conjure}
  :wbthomason/packer.nvim {}

  ;; UI
  :itchyny/lightline.vim {:mod :lightline}
  :cocopon/iceberg.vim {:mod :iceberg}
  :ncm2/float-preview.nvim {}
  :whatyouhide/vim-lengthmatters {:mod :lengthmatters}

  ;; Editing
  :tpope/vim-surround {}
  :wellle/targets.vim {}
  :jiangmiao/auto-pairs {:mod :auto-pairs}
  :easymotion/vim-easymotion {}
  :guns/vim-sexp {}
  :tpope/vim-sexp-mappings-for-regular-people {}

  ;; Tools
  :airblade/vim-gitgutter {}
  :nvim-telescope/telescope.nvim {}
  :Shougo/deoplete.nvim {:run ":UpdateRemotePlugins" :mod :deoplete}
  :deoplete-plugins/deoplete-lsp {}
  :dense-analysis/ale {:mod :ale}
  :neovim/nvim-lspconfig {:mod :lspconfig}
  :folke/which-key.nvim {}

  ;; Langs
  :hellerve/carp-vim {}
  :bakpakin/fennel.vim {}
  :bfrg/vim-cpp-modern {}
  :deoplete-plugins/deoplete-clang {}
  :wlangstroth/vim-racket {}

  ;;:hrsh7th/nvim-compe {}
  ;;:tami5/compe-conjure {}
  ;;:tpope/vim-abolish {}
  :tpope/vim-commentary {}
  ;;:tpope/vim-repeat {}
  :tpope/vim-sleuth {}
  :tpope/vim-unimpaired {}
  )
