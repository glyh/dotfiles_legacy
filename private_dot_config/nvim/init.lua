_G.GITHUB_CDN = "github.com.cnpmjs.org"

require("utils") -- Injects into global scope

-- Bootstrapping

ensure("wbthomason", "packer.nvim")

-- General

_G.LISP_FILE_TYPES = "clojure,fennel,janet,lisp"
_G.LISP_FILE_TYPES_TABLE = {"clojure", "fennel", "janet", "lisp"}

nvim.opt.termguicolors = true
nvim.opt.mouse = "a"
nvim.opt.updatetime = 500
nvim.opt.timeoutlen = 500
nvim.opt.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"
nvim.opt.completeopt = "menuone,noselect"
nvim.opt.list = true
nvim.opt.splitright = true
nvim.opt.hidden = true
nvim.opt.number = true
nvim.opt.wrap = false
nvim.opt.lazyredraw = true

-- Set up packer

require("packer").startup({function(use)

  ----- Package Manager -----

  use "wbthomason/packer.nvim"

  ----- FileType Support -----
  use {"bakpakin/fennel.vim",
    ft = "fennel"
  }

  use {"janet-lang/janet.vim",
    ft = "janet"
  }

  ----- UI -----

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

  ----- Editing -----

  -- use {"blackCauldron6/surround.nvim",
  --   config = function()
  --     require "surround".setup {}
  --   end
  -- }
  use "machakann/vim-sandwich"

  use "wellle/targets.vim"

  use {"windwp/nvim-autopairs",
    config = function()
      local autopairs = require('nvim-autopairs')
      autopairs.setup({
        disable_filetype = { "TelescopePrompt" , "vim" },
      })
      augroup("autopairs-custom",
        {{"FileType", LISP_FILE_TYPES, function()
          autopairs.remove_rule('`')
          autopairs.remove_rule("'")
        end}})
    end
  }

  -- use {"t9md/vim-smalls",
  --   config = function()
  --     nvim.g.smalls_jump_keys = ";ASDFGHJKLQWERTYUIOP"
  --   end}

  use {"eraserhd/parinfer-rust",
    ft = LISP_FILE_TYPES_TABLE,
    run = "cargo build --release",
  }
  use {"guns/vim-sexp",
    ft = LISP_FILE_TYPES_TABLE,
    config = function()
      nvim.g.sexp_filetypes = LISP_FILE_TYPES
    end
  }

  use {"tpope/vim-sexp-mappings-for-regular-people",
    ft = LISP_FILE_TYPES_TABLE,
    requires = "guns/vim-sexp",
  }

  use "tpope/vim-commentary"

  use "tpope/vim-sleuth"

  use "mg979/vim-visual-multi"

  use "kana/vim-arpeggio"

  use "tpope/vim-repeat"

  ----- Tools -----

  use {"Olical/conjure",
    ft = LISP_FILE_TYPES_TABLE,
    config = function()
      nvim.g["conjure#log#hud#border"] = "none"
      nvim.g["conjure#filetypes"] = LISP_FILE_TYPES
      -- -- nvim.g["conjure#filetypes_non_lisp"] = {"lua"}
      -- -- nvim.g["conjure#filetype#lua"] = "conjure.client.lua.neovim"
      -- -- nvim.g["conjure#filetype_suffixes#lua"] = {"lua"}
      nvim.g["conjure#client#fennel#aniseed#aniseed_module_prefix"] = "aniseed."
    end
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
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
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
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
    before = "nvim-telescope/telescope.nvim",
    config = function() require("nvim-mapper").setup({}) end
  }

  use {"hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function()
      require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
          border = { '', '' ,'', ' ', '', '', '', ' ' },
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };

        source = {
          path = true,
          buffer = true,
          nvim_lsp = true,
          nvim_lua = true,
          luasnip = true,
          conjure = true
        };
      }

    end
  }

  use {"tami5/compe-conjure",
    ft = LISP_FILE_TYPES_TABLE,
    requires = {"hrsh-8th/nvim-compe", "Olical/conjure"},
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
      nvim.g.ale_disable_lsp = 1 -- use neovim's built-in LSP client
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
          root_dir = lsputil.root_pattern(
            "project.clj", "deps.edn", ".git", "build.boot"),
          capabilities = capabilities
      }
      lspconfig.clangd.setup{
        capabilities = capabilities
      }
      lspconfig.rust_analyzer.setup{
        capabilities = capabilities
      }
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      lspconfig.sumneko_lua.setup {
        cmd = {"lua-language-server"},
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
              path = runtime_path,
            },
            diagnostics = {
              globals = {'vim'},
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
      -- TODO: Config diagnosticls
      -- lspconfig.diagnosticls.setup({
      --   filetypes={'*'},
      -- })
    end
  }

  -- Difference between requires & requires
  -- https://www.reddit.com/r/neovim/comments/opipij/guide_tips_and_tricks_to_reduce_startup_and/h67au5f?utm_source=share&utm_medium=web2x&context=3
  use { "nvim-telescope/telescope-frecency.nvim",
    requires = {"tami5/sql.nvim", "nvim-telescope/telescope.nvim"}
  }

  use { "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      -- for _, p in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
      --   p.install_info.url = p.install_info.url:gsub("github.com", GITHUB_CDN)
      -- end

      require("nvim-treesitter.configs").setup({
        ensure_installed =
        {"clojure", "fish", "c", "cpp", "rust", "query", "lua", "python",
         "fennel"},
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
          persist_queries = false,
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
    requires = "nvim-treesitter/nvim-treesitter"
  }
  use {"nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter/nvim-treesitter"
  }

  use "L3MON4D3/LuaSnip"

  use "mbbill/undotree"

end,config = {
  git = {default_url_format = "https://" .. GITHUB_CDN .. "/%s"}
}})

require("mappings")
