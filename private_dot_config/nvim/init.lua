local utils = require("utils")
local bridge = utils.bridge

nvim = utils.nvim
ensure = utils.ensure
augroup = utils.augroup

-- Bootstrapping

ensure("wbthomason", "packer.nvim")

-- General

local lisp_file_types = "clojure,fennel"

nvim.o.termguicolors = true
nvim.o.mouse = "a"
nvim.o.updatetime = 500
nvim.o.timeoutlen = 500
nvim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"
nvim.o.completeopt = "menuone,noselect"
nvim.o.list = true
nvim.o.splitright = true
nvim.o.hidden = true
nvim.o.number = true
nvim.opt.wrap = false

-- Set up packer

require("packer").startup({function()

  ----- package manager -----

  use "wbthomason/packer.nvim"

  ----- ui -----

  use {"itchyny/lightline.vim",
    config = function()
      nvim.g.lightline = {colorscheme = "iceberg"}
    end
  }

  use {"cocopon/iceberg.vim",
    config = function()
      nvim.cmd("colorscheme iceberg")
    end
  }

  use {"whatyouhide/vim-lengthmatters",
    config = function()
      nvim.g["lengthmatters_excluded"] = {
        "unite", "tagbar", "startify", "gundo", "vimshell", "w3m", "nerdtree",
        "help", "qf", "dirvish", "markdown", "tex",
        "conjure-log-[0-9]\\+\\.[a-z]\\+"
      }
    end
  }

  use {"beauwilliams/focus.nvim",
    config = function()
      require("focus").width = math.floor(0.6 * nvim.o.columns)
    end
  }

  use {"ncm2/float-preview.nvim",
    config = function()
      nvim.g["float_preview#docked"] = false
      nvim.g["float_preview#max_width"] = 80
      nvim.g["float_preview#max_height"] = 40
    end
  }

  ----- editing -----

  use "tpope/vim-surround"

  use "wellle/targets.vim"

  use {"jiangmiao/auto-pairs",
    config = function()
      augroup("auto_pair",
        {{"filetype", lisp_file_types, function()
          local auto_pairs = nvim.g.AutoPairs
          auto_pairs["'"] = nil
          auto_pairs["`"] = nil
        end}})
    end
  }

  use {"t9md/vim-smalls",
    config = function()
      nvim.g.smalls_jump_keys = ";ASDFGHJKLQWERTYUIOP"
    end}

  use {"guns/vim-sexp",
    config = function()
      nvim.g.sexp_filetypes = lisp_file_types
    end
  }

  use {"tpope/vim-sexp-mappings-for-regular-people",
    requires = "guns/vim-sexp",
  }

  use "tpope/vim-commentary"

  use "tpope/vim-sleuth"

  use "mg979/vim-visual-multi"

  use "kana/vim-arpeggio"

  use "tpope/vim-repeat"

  ----- tools -----

  use {"Olical/conjure",
    config = function()
      nvim.g["conjure#log#hud#border"] = "none"
      nvim.g["conjure#filetypes"] = lisp_file_types
      -- nvim.g["conjure#filetypes_non_lisp"] = {"lua"}
      -- nvim.g["conjure#filetype#lua"] = "conjure.client.lua.neovim"
      -- nvim.g["conjure#filetype_suffixes#lua"] = {"lua"}
      nvim.g["conjure#client#fennel#aniseed#aniseed_module_prefix"] = "aniseed."
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use { "nvim-telescope/telescope.nvim",
    requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"},
    config = function()
      local tele = require("telescope")
      tele.setup({
        pickers = {
          buffers = {
            theme = "dropdown",
            previewer = false
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        }
      })
      tele.load_extension('fzf')
      tele.load_extension("frecency")
      tele.load_extension("mapper")
    end
  }
  use {'nvim-telescope/telescope-fzf-native.nvim',
    requires = "nvim-telescope/telescope.nvim",
    run = 'make'
  }
  use { "lazytanuki/nvim-mapper",
    requires = "nvim-telescope/telescope.nvim",
    before = "nvim-telescope/telescope.nvim",
    config = function() require("nvim-mapper").setup{} end
  }

  use { "Shougo/deoplete.nvim",
    run = {"UpdateRemotePlugins"},
    config = function()
      nvim.g["deoplete#enable_at_startup"] = 1
      nvim.fn["deoplete#custom#option"]('keyword_patterns', {
        clojure= "[\\w!$%&*+/:<=>?@\\^_~\\-\\.#]*"
      })
      nvim.cmd([[
        autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)
      ]])
    end
  }
  use { "deoplete-plugins/deoplete-lsp",
    requires = "Shougo/deoplete.nvim"
  }

  use {"dense-analysis/ale",
    config = function()
      nvim.g.ale_lint_on_text_changed = true
      nvim.g.ale_fixers = {["*"]={"remove_trailing_lines", "trim_whitespace"}}
      nvim.g.ale_fix_on_save = true
      nvim.g.ale_pattern_options = {
        ["conjure-log-[0-9]\\+\\.[a-z]\\+"] = {
          ["ale_linters"] = {},
          ["ale_fixers"] = {}
        }
      }
      nvim.g.ale_disable_lsp = 1 -- We already have neovim's built in lsp
    end
  }

  use {"neovim/nvim-lspconfig",
    config=function()
      local capabilities = nvim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }

      local lspconfig = require("lspconfig")
      local lsputil = require("lspconfig.util")
      lspconfig.clojure_lsp.setup{
          cmd = { "clojure-lsp" },
          filetypes = { "clojure", "edn" },
          root_dir =
            lsputil.root_pattern("project.clj", "deps.edn", ".git", "build.boot"),
      }
      lspconfig.clangd.setup{ }
      lspconfig.rust_analyzer.setup{  }
    end
  }

  use { "nvim-telescope/telescope-frecency.nvim",
    requires = {"nvim-telescope/telescope.nvim", "tami5/sql.nvim"}
  }

  use { "nvim-treesitter/nvim-treesitter",
    run = "TSUpdate",
    config = function()
      for _, p in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
        p.install_info.url = p.install_info.url:gsub("github.com", "hub.fastgit.org")
      end

      require("nvim-treesitter.configs").setup({
        ensure_installed =
        {"clojure", "fish", "c", "cpp", "rust", "query", "lua", "python", "fennel"},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<localleader>v",
            node_incremental = "go",
            node_decremental = "gi",
          }
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          -- debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'i',
            focus_language = 'f',
            unfocus_language = 'f',
            update = 'r',
            goto_node = '<CR>',
            show_help = '?',
          }
        },
        textobjects = {
          select = {
            enable = true,

            -- automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            }
          },
        },
      })
    end
  }
  use { "nvim-treesitter/playground",
    requires = {"nvim-treesitter/nvim-treesitter"}
  }
  use {"nvim-treesitter/nvim-treesitter-textobjects",
    requires = {"nvim-treesitter/nvim-treesitter"}
  }

  -- language specific
  use "bakpakin/fennel.vim"

  use "janet-lang/janet.vim"

  use { "deoplete-plugins/deoplete-clang",
    requires = "shougo/deoplete.nvim"
  }

end,config = {
  git = {default_url_format = "https://hub.fastgit.org/%s"}
}})

require("mappings")
