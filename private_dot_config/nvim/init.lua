-- Shortcuts

str = string
utils = require("utils")
nvim = utils.nvim
augroup = utils.augroup
bridge = utils.bridge


-- Bootstrapping

local pack_path = nvim.fn.stdpath("data") .. "/site/pack"

function ensure(user, repo)
  -- Ensures a given github.com/user/repo is cloned in the
  -- Pack/packer/start directory.
  local install_path =
  string.format("%s/packer/start/%s", pack_path, repo, repo)
  if nvim.fn.empty(nvim.fn.glob(install_path)) > 0 then
    nvim.cmd(string.format("!git clone https://github.com/%s/%s %s",
    user, repo, install_path))
    nvim.cmd(string.format("packadd %s", repo))
  end
end

-- bootstrap some specific plugins
ensure("wbthomason", "packer.nvim")


-- plugins

require("packer").startup({function()

  -- package manager
  use "wbthomason/packer.nvim"

  -- configuration
  use "norcalli/nvim_utils"

  -- ui
  use "itchyny/lightline.vim"
  use "cocopon/iceberg.vim"
  use "whatyouhide/vim-lengthmatters"
  use "beauwilliams/focus.nvim"

  -- editing
  use "tpope/vim-surround"
  use "wellle/targets.vim"
  use "jiangmiao/auto-pairs"
  use "easymotion/vim-easymotion"
  use "guns/vim-sexp"
  use {"tpope/vim-sexp-mappings-for-regular-people",
    requires = "guns/vim-sexp",
  }
  use "tpope/vim-commentary"
  use "tpope/vim-sleuth"
  use "mg979/vim-visual-multi"
  -- use "tpope/vim-repeat"

  -- tools
  use "Olical/conjure"

  use "airblade/vim-gitgutter"
  use { "nvim-telescope/telescope.nvim",
    requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}
  }
  use { "lazytanuki/nvim-mapper",
    requires = "nvim-telescope/telescope.nvim"
  }
  use "hrsh7th/nvim-compe"
  use "hrsh7th/vim-vsnip"
  use { "tami5/compe-conjure", requires = "hrsh7th/nvim-compe" }
  use "dense-analysis/ale"

  use "neovim/nvim-lspconfig"
  use { "nvim-telescope/telescope-frecency.nvim",
    requires = {"nvim-telescope/telescope.nvim", "tami5/sql.nvim"}
  }
  use { "nvim-treesitter/nvim-treesitter",
    run = "tsupdate"
  }
  use { "nvim-treesitter/playground",
    requires = {"nvim-treesitter/nvim-treesitter"}
  }
  use {"nvim-treesitter/nvim-treesitter-textobjects",
    requires = {"nvim-treesitter/nvim-treesitter"}
  }

  -- language specific
  use "bakpakin/fennel.vim"
  use "Olical/aniseed"
end,config = {
  git = {default_url_format = "https://hub.fastgit.org/%s"}
}})


-- Some basic informations

local lisp_file_types = "clojure,fennel"


-- general

nvim.o.termguicolors = true
nvim.o.mouse = "a"
nvim.o.updatetime = 500
nvim.o.timeoutlen = 500
nvim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"
nvim.o.completeopt = "menuone,noselect"
nvim.o.list = true
nvim.o.number = true
nvim.o.splitright = true
nvim.o.hidden = true
nvim.cmd("set nowrap") -- nvim.o.nowrap = true


-- ui

nvim.cmd("colorscheme iceberg")
nvim.g.lightline = {colorscheme = "iceberg"}
nvim.g["float_preview#docked"] = false
nvim.g["float_preview#max_width"] = 80
nvim.g["float_preview#max_height"] = 40
nvim.g["lengthmatters_exluded"] = {
  "unite", "tagbar", "startify", "gundo", "vimshell", "w3m", "nerdtree", "help",
  "qf", "dirvish", "markdown", "tex", "conjure-log-[0-9]\\+\\.[a-z]\\+", ".*\\.md"
}
require("focus").width = math.floor(0.6 * nvim.o.columns)

-- telescope
local tele = require("telescope")
local mapper = require("nvim-mapper")
tele.load_extension("frecency")
tele.load_extension("mapper")
tele.setup {pickers = {buffers = { theme = "dropdown", previewer = false }}}
mapper.setup {no_map = true}


-- ide supports:

-- linter
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

-- interactive development
nvim.g["conjure#log#hud#border"] = "none"
nvim.g["conjure#filetypes"] = {"clojure", "fennel", "janet", "racket", "scheme"}
nvim.g["conjure#filetypes_non_lisp"] = {"lua"}
--lisp_file_types .. ",lua"
nvim.g["conjure#filetype#lua"] = "conjure.client.lua.neovim"
nvim.g["conjure#filetype_suffixes#lua"] = {"lua"}
nvim.g["conjure#client#fennel#aniseed#aniseed_module_prefix"] = "aniseed."

-- editing
augroup("auto_pair",
  {{"filetype", lisp_file_types, function()
    local auto_pairs = nvim.g.AutoPairs
    auto_pairs["'"] = nil
    auto_pairs["`"] = nil
  end}}
)
nvim.g.sexp_filetypes = lisp_file_types
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
    -- the border option is the same as `|help nvim_open_win|`
    winhighlight =
      "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
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
    treesitter = true,
    vsnip = true,
    conjure = true
  };
}

-- LSP
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
local lspconfig_util = require("lspconfig.util")
lspconfig.clojure_lsp.setup{
    cmd = { "clojure-lsp" },
    filetypes = { "clojure", "edn" },
    root_dir =
      lspconfig_util.root_pattern("project.clj", "deps.edn", ".git", "build.boot"),
}
lspconfig.clangd.setup{ }

-- treesitter
for _, p in pairs(require "nvim-treesitter.parsers".get_parser_configs()) do
  p.install_info.url = p.install_info.url:gsub("github.com", "hub.fastgit.org")
end

require("nvim-treesitter.configs").setup {
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
}

require("mappings")
