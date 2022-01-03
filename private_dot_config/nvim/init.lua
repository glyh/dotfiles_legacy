-- _G.GITHUB_CDN = 'github.com.npmjs.org'
_G.GITHUB_CDN = 'hub.fastgit.org'
_G.HOME_LANG = 'zh'

local utils = require('utils')

-- Bootstrapping

utils.ensure('wbthomason', 'packer.nvim')
utils.ensure('nvim-lua', 'plenary.nvim')

-- General

_G.LISP_FILE_TYPES = 'clojure,fennel,janet,racket'
_G.LISP_FILE_TYPES_TABLE = {'clojure', 'fennel', 'janet', 'racket'}

vim.opt.completeopt = 'menuone,noselect'
vim.opt.expandtab = true
vim.opt.guifont="FiraCode Nerd Font:h12"
vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize'
vim.opt.shiftwidth = 4
vim.opt.splitbelow = false
vim.opt.splitright = true
vim.opt.updatetime = 500
vim.opt.wrap = false
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Auto Reload
utils.augroup('LuaAutoConfReload',
  {{'BufWritePost', '*.lua', function()
    local path = vim.fn.expand('%:p')
    local file = require('plenary.path').new(path)
    local parents = file:parents()
    local rtps = vim.api.nvim_list_runtime_paths()
    for _, parent in ipairs(parents) do
        for _, rtp in ipairs(rtps) do
            if parent == rtp then
                vim.cmd("luafile %")
                vim.cmd("PackerCompile")
                return
            end
        end
    end
  end}})

-- Set up packer
require('packer').startup({function(use)

  ----- Package Manager -----

  use {'wbthomason/packer.nvim',
    config = function()
        vim.api.nvim_set_keymap(
          'n', '<leader>pu', '<cmd>PackerSync<CR>', {noremap = true})
        vim.api.nvim_set_keymap(
          'n', '<leader>ps', '<cmd>PackerStatus<CR>', {noremap = true})
    end
  }

  ----- Base library -----

  use 'nvim-lua/plenary.nvim'

  ----- FileType Support -----

  use {'zah/nim.vim', ft = 'nim' }
  use {'bakpakin/fennel.vim', ft = 'fennel'}
  use {'janet-lang/janet.vim', ft = 'janet'}
  use {'wlangstroth/vim-racket', ft = 'racket'}

  use {'nvim-neorg/neorg',
    after = 'nvim-treesitter',
    config = function()
      require('neorg').setup({
         load = {
           ["core.defaults"] = {}, -- Load all the default modules
           ["core.norg.concealer"] = {}, -- Allows for use of icons
           ["core.norg.dirman"] = { -- Manage your directories with Neorg
             config = {
               workspaces = {
                 my_workspace = "~/Documents/Neorg"
               }
             }
           },
        }
      })
    end,
    requires = 'nvim-lua/plenary.nvim'
  }

  use {'lervag/vimtex',
    ft = 'tex',
    config = function()
      vim.g.vimtex_view_enabled = true
      vim.g.vimtex_view_method = 'zathura'
    end
  }

  use {'lark-parser/vim-lark-syntax', ft = 'lark' }

  ----- UI -----

  use { 'chrisbra/Colorizer' }


  use {'itchyny/lightline.vim',
    config = function()
      vim.g.lightline = { colorscheme = 'nord' }
    end
  }

  use {'shaunsingh/nord.nvim',
    config = function()
      vim.cmd([[
         colorscheme nord
         syntax enable
      ]])
      -- vim.api.exec([[
      --   colorscheme nord
      --   syntax enable
      -- ]], true)
    end
  }

  use {'whatyouhide/vim-lengthmatters',
    config = function()
      vim.g['lengthmatters_excluded'] = {
        'unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree',
        'help', 'qf', 'dirvish', 'markdown', 'tex', 'man',
        'conjure-log-[0-9]\\+\\.[a-z]\\+', 'OUTLINE'
      }
    end,
  }

  use {'beauwilliams/focus.nvim',
    config = function()
      require('focus').setup({
        enable = true,
        width = math.floor(0.6 * vim.o.columns)
      })
    end,
  }

  use { 'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup()
    end,
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
    end,
  }

  use {'lukas-reineke/indent-blankline.nvim',
    config = function ()
      require('indent_blankline').setup {
        char = '|',
        buftype_exclude = {'terminal'},
        bufname_exclude = {'OUTLINE'},
        filetype_exclude = {'help', 'packer', 'markdown', 'man', 'result'}
      }
    end
  }

  ----- Editing -----

  use 'machakann/vim-sandwich'

  use 'wellle/targets.vim'

  use {'windwp/nvim-autopairs',
    config = function()
      local utils = require('utils')
      local autopairs = require('nvim-autopairs')
      autopairs.setup({
        disable_filetype = { 'TelescopePrompt' , 'vim' },
      })
      utils.augroup('autopairs-custom',
        {{'FileType', LISP_FILE_TYPES, function()
          autopairs.remove_rule('`')
          autopairs.remove_rule("'")
      end}})
    end
  }

  use { 'phaazon/hop.nvim',
    config = function()
      require'hop'.setup { keys = 'fhdjskalgryeuwiqot' }
      vim.api.nvim_set_keymap('n', 'f', '<cmd>HopChar2<CR>', {noremap = true})
      vim.api.nvim_set_keymap('v', 'f', '<cmd>HopChar2<CR>', {noremap = true})
      vim.api.nvim_set_keymap('o', 'f', '<cmd>HopChar2<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', 'F',
        "<cmd>lua require('hop').hint_patterns({case_insensitive = false})<CR>",
        {noremap = true})
      vim.api.nvim_set_keymap('v', 'F',
        "<cmd>lua require('hop').hint_patterns({case_insensitive = false})<CR>",
        {noremap = true})
      vim.api.nvim_set_keymap('o', 'F',
        "<cmd>lua require('hop').hint_patterns({case_insensitive = false})<CR>",
        {noremap = true})
    end
  }

  use {'eraserhd/parinfer-rust',
    ft = LISP_FILE_TYPES_TABLE,
    run = 'cargo build --release',
  }
  use {'guns/vim-sexp',
    ft = LISP_FILE_TYPES_TABLE,
    config = function()
      vim.g.sexp_filetypes = LISP_FILE_TYPES
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

  -- use {'akinsho/toggleterm.nvim',
  --   config = require('plugins.toggleterm')
  -- }

  use {'kevinhwang91/rnvimr',
    config = function ()
      vim.g.rnvimr_enable_ex = 1
      vim.g.rnvimr_enable_picker = 1
      vim.api.nvim_set_keymap(
        'n', '<C-o>', '<cmd>RnvimrToggle<CR>', {noremap = true})
    end
  }

  -- use {'rafcamlet/nvim-luapad',
  --   config = function()
  --     api.set_keymap('n', '<leader>lp', '<cmd>Luapad<CR>', {noremap = true})
  --   end
  -- }

  use {'skywind3000/asyncrun.vim',
    config = function()
      -- g.asyncrun_open = 6
      vim.api.nvim_set_keymap('c', '!,', 'AsyncRun ', {noremap = true})
    end
  }
  use {'skywind3000/asynctasks.vim',
    config = function()
      vim.g.asyncrun_rootmarks = {
        '.git', '.svn', '.root', '.project', '.hg',
        'Cargo.toml', '.nimble'
      }
      vim.api.nvim_set_keymap(
        'n', '<localleader>ab', '<cmd>AsyncTask build<CR>', {noremap = true})
      vim.api.nvim_set_keymap(
        'n', '<localleader>ar', '<cmd>AsyncTask run<CR>', {noremap = true})
    end
  }

  use {'simrat39/symbols-outline.nvim',
    config = function()
      vim.api.nvim_set_keymap(
        'n', '<leader>o', '<cmd>SymbolsOutline<CR>', {noremap = true})
    end
  }

  local utils = require('utils')
  use {'glyh/conjure',
    branch = 'lua-suppport',
    ft = utils.array_concat(LISP_FILE_TYPES_TABLE, {'lua'} ),
    config = function()
      local utils = require('utils')
      vim.g['conjure#log#hud#border'] = 'none'
      vim.g['conjure#filetypes'] = LISP_FILE_TYPES .. ',lua'
      vim.g['conjure#extract#tree_sitter#enabled'] = true
      vim.g['conjure#mapping#eval_visual'] = 'e'
      local toggle = function ()
        local re = vim.regex('conjure-log-[0-9]\\+\\.[a-z]\\+$')
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
           if re:match_str(
             vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)))
             and vim.api.nvim_win_get_config(win).focusable then
            vim.cmd('ConjureLogCloseVisible')
            return
           end
        end
        vim.cmd('ConjureLogVSplit')
      end
      -- NOTE: sometimes we'll focus on a non-conjure buffer, I use
      -- pcall to workaround this.
      vim.api.nvim_set_keymap( 'n', '<localleader>ll',
        utils.bridge(function() pcall(toggle) end , 'cmd_keys') , {noremap = true})
    end
  }

  use {'mfussenegger/nvim-dap',
    config = require('plugins.dap'),
  }
  use {'rcarriga/nvim-dap-ui',
    requires = 'mfussenegger/nvim-dap',
    config = function()
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup {}
      dap.listeners.after.event_initialized.dapui_config =
        function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config =
        function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config =
        function() dapui.close() end
    end
  }
  use 'jbyuki/one-small-step-for-vimkind'

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
  use { 'nvim-telescope/telescope-dap.nvim',
    requires = 'nvim-telescope/telescope.nvim',
  }
  use {'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup{}
    end
  }

  use { 'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
      vim.api.nvim_set_keymap(
        'n', '<leader>t', '<cmd>TroubleToggle<CR>', {noremap = true})
    end
  }

  use {'L3MON4D3/LuaSnip', event = 'InsertEnter' }

  use {'hrsh7th/nvim-cmp',
    after = 'neorg', -- LuaSnip dispatches in runtime
    event = {'InsertEnter', 'CmdlineEnter'},
    config = require('plugins.cmp')
  }
  use {'hrsh7th/cmp-buffer', after = 'nvim-cmp'}
  use {'hrsh7th/cmp-path', after = 'nvim-cmp'}
  use {'hrsh7th/cmp-cmdline', after = 'nvim-cmp'}
  use {'saadparwaiz1/cmp_luasnip', after = "nvim-cmp"}
  use {'hrsh7th/cmp-nvim-lsp', after = "nvim-cmp"}

  use {'neovim/nvim-lspconfig', config = require('plugins.lspconfig') }

  use {'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup {
        sources = {
          -- general
          null_ls.builtins.formatting.trim_newlines,
          null_ls.builtins.formatting.trim_whitespace
        },
        on_attach = function(client)
          if client.resolved_capabilities.document_formatting then
            vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()')
          end
        end
      }
    end
  }

  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('plugins.treesitter')
  }
  use { 'stephenprater/playground',
    branch = 'fix-display-highlight-groups',
    requires = 'nvim-treesitter/nvim-treesitter'
  }
  use {'nvim-treesitter/nvim-treesitter-textobjects',
    requires = 'nvim-treesitter/nvim-treesitter'
  }

  use {'mbbill/undotree',
    config = function()
      vim.api.nvim_set_keymap(
        'n', '<leader>u', '<cmd>UndotreeToggle<CR>', {noremap = true})
    end
  }

  use {'voldikss/vim-translator',
    config = function()
      -- g.translator_window_type = 'preview'
      vim.g.translator_target_lang = 'zh'
      vim.g.translator_default_engines = {'bing'}
      vim.api.nvim_set_keymap("n", "t", "<Plug>TranslateW", {})
      vim.api.nvim_set_keymap("v", "t", "<Plug>TranslateWV", {})
    end
  }

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

end,config = {
  git = { default_url_format = 'https://' .. _G.GITHUB_CDN .. '/%s' }
}})

require('mappings')
