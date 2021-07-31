(module magic.plugin
  {autoload {a aniseed.core
             packer packer}})

(defn- safe-require-plugin-config [name]
  "Safely require a module under the magic.plugin.* prefix. Will catch errors
  and print them while continuing execution, allowing other plugins to load
  even if one configuration module is broken."
  (let [(ok? val-or-err) (pcall require (.. "magic.plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn- req [name]
  "A shortcut to building a require string for your plugin
  configuration. Intended for use with packer's config or setup
  configuration options. Will prefix the name with `magic.plugin.`
  before requiring."
  (.. "require('magic.plugin." name "')"))

(defn- use [config ...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well.

  This is just a helper / syntax sugar function to make interacting with packer
  a little more concise."
  (let [pkgs [...]]
    (packer.startup
      {1 (fn [use]
          (for [i 1 (a.count pkgs) 2]
            (let [name (. pkgs i)
                  opts (. pkgs (+ i 1))]
              (-?> (. opts :mod) (safe-require-plugin-config))
              (use (a.assoc opts 1 name)))))
       :config config})))

(defn init []
  ;; Packer configuration format: https://github.com/wbthomason/packer.nvim
  (use
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
    :tpope/vim-unimpaired {}))
