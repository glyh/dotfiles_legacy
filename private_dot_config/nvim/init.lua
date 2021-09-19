_G.GITHUB_CDN = 'hub.fastgit.org' --'github.com.cnpmjs.org'

require('utils') -- Injects into global scope

-- Bootstrapping

ensure('wbthomason', 'packer.nvim')
-- Speed up lua
prequire('impatient')

-- General

_G.LISP_FILE_TYPES = 'clojure,fennel,janet,lisp'
_G.LISP_FILE_TYPES_TABLE = {'clojure', 'fennel', 'janet', 'lisp'}

nvim.opt.termguicolors = true
nvim.opt.mouse = 'a'
nvim.opt.updatetime = 500
nvim.opt.timeoutlen = 500
nvim.opt.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize'
nvim.opt.completeopt = 'menuone,noselect'
nvim.opt.list = true
nvim.opt.splitright = true
nvim.opt.hidden = true
nvim.opt.number = true
nvim.opt.wrap = false
nvim.opt.lazyredraw = true
nvim.opt.expandtab = true
nvim.opt.shiftwidth = 4

-- Set up packer

require('packer').startup({function(use)

  ----- Package Manager -----

  use 'wbthomason/packer.nvim'

  ----- Profiling -----
  use 'lewis6991/impatient.nvim'

  ----- FileType Support -----

  -- use {'bakpakin/fennel.vim',
  --   ft = 'fennel'
  -- }

  use {'janet-lang/janet.vim',
    ft = 'janet'
  }

  use {'zah/nim.vim',
    ft = 'nim'
  }

  use {'nvim-neorg/neorg',
    ft = 'norg',
    config = function()
      require('neorg').setup({
        load = {
          ['core.defaults'] = {
            config = {
              disable = (function()
                if prequire('compe') then
                  return {}
                else
                  return { 'core.norg.completion' }
                end
              end)()
            }
          },
          -- ......
        }
      })
    end,
    requires = 'nvim-lua/plenary.nvim'
  }

  ----- UI -----

  use {'itchyny/lightline.vim',
    config = function()
      nvim.g.lightline = {colorscheme = 'iceberg'}
    end
  }

  use {'cocopon/iceberg.vim',
    config = function()
      nvim.cmd('colorscheme iceberg')
    end
  }

  use {'whatyouhide/vim-lengthmatters',
    config = function()
      nvim.g['lengthmatters_excluded'] = {
        'unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree',
        'help', 'qf', 'dirvish', 'markdown', 'tex',
        'conjure-log-[0-9]\\+\\.[a-z]\\+'
      }
    end
  }

  use {'beauwilliams/focus.nvim',
    config = function()
      require('focus').width = math.floor(0.6 * nvim.o.columns)
    end
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use {'folke/todo-comments.nvim',
    config = function ()
      require('todo-comments').setup {
          keywords = {
            FIX = {
              icon = " ", -- icon used for the sign, and in search results
              color = "error", -- can be a hex color, or a named color (see below)
              alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
              -- signs = false, -- configure signs for some keywords individually
            },
            TODO = { icon = " ", color = "info" },
            OK = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" , "ERROR"} },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          },
      }
    end
  }

  use {'lukas-reineke/indent-blankline.nvim',
    config = function ()
      require('indent_blankline').setup {
        char = '|',
        buftype_exclude = {'terminal'}
      }
    end
  }

  ----- Editing -----

  use 'machakann/vim-sandwich'

  use 'wellle/targets.vim'

  use {'windwp/nvim-autopairs',
    config = function()
      local autopairs = require('nvim-autopairs')
      autopairs.setup({
        disable_filetype = { 'TelescopePrompt' , 'vim' },
      })
      augroup('autopairs-custom',
        {{'FileType', LISP_FILE_TYPES, function()
          autopairs.remove_rule('`')
          autopairs.remove_rule("'")
        end}})
    end
  }

  use { 'phaazon/hop.nvim',
    config = function()
      require'hop'.setup { keys = 'fhdjskalgryeuwiqot' }
    end
  }

  use {'eraserhd/parinfer-rust',
    ft = LISP_FILE_TYPES_TABLE,
    run = 'cargo build --release',
  }
  use {'guns/vim-sexp',
    ft = LISP_FILE_TYPES_TABLE,
    config = function()
      nvim.g.sexp_filetypes = LISP_FILE_TYPES
    end
  }

  use {'tpope/vim-sexp-mappings-for-regular-people',
    ft = LISP_FILE_TYPES_TABLE,
    requires = 'guns/vim-sexp',
  }

  use 'tpope/vim-commentary'

  use 'tpope/vim-sleuth'

  use 'mg979/vim-visual-multi'

  use 'kana/vim-arpeggio'

  use 'tpope/vim-repeat'

  ----- Tools -----

  use {'Olical/conjure',
    ft = LISP_FILE_TYPES_TABLE,
    config = function()
      nvim.g['conjure#log#hud#border'] = 'none'
      nvim.g['conjure#filetypes'] = LISP_FILE_TYPES
      nvim.g['conjure#client#fennel#aniseed#aniseed_module_prefix'] = 'aniseed.'
    end
  }

  use {'mfussenegger/nvim-dap',
  }

  use { 'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = require('plugins.telescope')
  }
  use { 'nvim-telescope/telescope-frecency.nvim',
    requires = {'tami5/sql.nvim', 'nvim-telescope/telescope.nvim'}
  }
  use {'nvim-telescope/telescope-fzf-native.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    run = 'make'
  }
  use { 'lazytanuki/nvim-mapper',
    before = 'nvim-telescope/telescope.nvim',
    config = function() require('nvim-mapper').setup({}) end
  }

  use { 'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {'hrsh7th/nvim-compe',
    event = 'InsertEnter',
    config = require('plugins.compe')
  }

  use {'tami5/compe-conjure',
    ft = LISP_FILE_TYPES_TABLE,
    requires = {'hrsh-8th/nvim-compe', 'Olical/conjure'},
  }

  use {'dense-analysis/ale',
    config = function()
      nvim.g.ale_lint_on_text_changed = true
      nvim.g.ale_fixers = {['*']={'remove_trailing_lines', 'trim_whitespace'}}
      nvim.g.ale_fix_on_save = true
      nvim.g.ale_pattern_options = { -- turn off ale for conjure's log
        ['conjure-log-[0-9]\\+\\.[a-z]\\+'] = {
          ['ale_linters'] = {},
          ['ale_fixers'] = {}
        }
      }
      nvim.g.ale_disable_lsp = 1 -- use neovim's built-in LSP client
    end
  }

  use {'neovim/nvim-lspconfig',
    config = require('plugins.lspconfig')
  }


  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('plugins.treesitter')
  }
  use { 'nvim-treesitter/playground',
    requires = 'nvim-treesitter/nvim-treesitter'
  }
  use {'nvim-treesitter/nvim-treesitter-textobjects',
    requires = 'nvim-treesitter/nvim-treesitter'
  }

  use {'romgrk/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function ()
    require('treesitter-context').setup({
      enable = true,
      throttle = true,
    })
    end
  }

  use 'L3MON4D3/LuaSnip'

  use 'mbbill/undotree'

  use {'voldikss/vim-translator',
    config = function()
      vim.api.nvim_set_keymap("n", "t", "<Plug>TranslateW", {})
      vim.api.nvim_set_keymap("v", "t", "<Plug>TranslateWV", {})
    end
  }

end,config = {
  git = { default_url_format = 'https://' .. GITHUB_CDN .. '/%s' }
}})

require('mappings')
