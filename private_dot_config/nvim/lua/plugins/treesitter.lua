return function()
  local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

  parser_configs.norg = {
      install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg",
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main"
      },
  }

  parser_configs.norg_meta = {
      install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
          files = { "src/parser.c" },
          branch = "main"
      },
  }

  parser_configs.norg_table = {
      install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
          files = { "src/parser.c" },
          branch = "main"
      },
  }

  for _, p in pairs(require('nvim-treesitter.parsers').get_parser_configs()) do
    p.install_info.url = p.install_info.url:gsub('github.com', GITHUB_CDN)
  end

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c', 'cpp', 'rust', 'lua', 'python', 'norg', 'norg_meta', 'norg_table',
      'fennel', 'query'
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<localleader>v',
        node_incremental = 'go',
        node_decremental = 'gi',
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
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        }
      },
    },
  })
end
