local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local indent = 2
cmd 'colorscheme iceberg'
opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'termguicolors', true)                       -- True color support
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'number', true)                              -- Print line number
opt('w', 'relativenumber', false)                      -- Relative line numbers
opt('w', 'wrap', false)                               -- Disable line wrap

vim.g.lightline = {
	colorscheme = 'iceberg'
}

vim.g.float_preview = {
  docked = false,
  max_width = 80,
  max_height = 40,
}

vim.g.lengthmatters_excluded = {'unite', 'tagbar', 'startify', 'gundo',
	'vimshell', 'w3m', 'nerdtree', 'help', 'qf', 'dirvish', 'markdown',
	'conjure-log-[0-9]\\+\\.cljc'}

vim.g.deoplete = {
	enable_at_startup = true,
	sources = {
		clang = {
			libclang_path = '/usr/lib/libclang.so',
			clang_header = '/usr/include'

		}
	}

}
vim.fn["deoplete#custom#option"]('keyword_patterns', {
	clojure = '[\\w!$%&*+/:<=>?@\\^_~\\-\\.#]*'
})

vim.api.nvim_set_keymap('i', '<S-TAB>', 'pumvisible() ? "\\<Up>" : "\\<TAB>"', { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<TAB>', 'pumvisible() ? "\\<Down>" : "\\<TAB>"', { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', { noremap = true, expr = true })

vim.g.ale_lint_on_text_changed = true
vim.g.ale_fixers = {
	['*'] = {'remove_trailing_lines', 'trim_whitespace'}
}
vim.g.ale_fix_on_save = true

require'lspconfig'.clangd.setup{}
require'lspconfig'.clojure_lsp.setup{}
require'lspconfig'.nimls.setup{}

