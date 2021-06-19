call plug#begin('~/.config/nvim/plugged')

"Dependences
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

" UI
Plug 'itchyny/lightline.vim' " statusline
" nord-vim conflicts with lightline, it should be loaded after lightline
Plug 'cocopon/iceberg.vim' " colorscheme
Plug 'ncm2/float-preview.nvim' " autocomplete float preview
Plug 'whatyouhide/vim-lengthmatters' " 80 char highlight

" Editing
Plug 'tpope/vim-surround' " surround
Plug 'wellle/targets.vim' " targets
Plug 'jiangmiao/auto-pairs' " autopairs
Plug 'easymotion/vim-easymotion' " optimized motions
Plug 'guns/vim-sexp' " S expression edit
Plug 'tpope/vim-sexp-mappings-for-regular-people' " sexp mapping

" Tools
Plug 'airblade/vim-gitgutter' " git
Plug 'nvim-telescope/telescope.nvim' " git
" Plug 'Shougo/denite.nvim' " fzf
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocomplete
Plug 'deoplete-plugins/deoplete-lsp' " LSP integration with deoplete
Plug 'dense-analysis/ale' " linter
" Plug 'Shougo/defx.nvim' " filer
Plug 'neovim/nvim-lspconfig'

" Lang#Clojure
Plug 'Olical/conjure' " REPL integration

" Lang#Carp
"Plug 'hellerve/carp-vim'

" Lang#Fennel
Plug 'bakpakin/fennel.vim'

" Lang#Idris
" Plug 'edwinb/idris2-vim' " Bundle

" Lang#C/Cpp
Plug 'bfrg/vim-cpp-modern' " Highlight
Plug 'deoplete-plugins/deoplete-clang'
" Plug 'vhdirk/vim-cmake'

" Lang#nim
Plug 'zah/nim.vim' " Bundle

" Lang#zig
Plug 'ziglang/zig.vim' " Bundle

" Lang#markdown
" Plug 'gabrielelana/vim-markdown' " Syntax and edit
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" Plug 'oknozor/illumination', { 'dir': '~/.illumination', 'do': '.install.sh' }

call plug#end()

" lightline.vim
let g:lightline = {
      \   'colorscheme': 'iceberg',
      \ }

" iceberg
colorscheme iceberg


" float-preview.nvim
let g:float_preview#docked = 0
let g:float_preview#max_width = 80
let g:float_preview#max_height = 40
set completeopt-=preview

" lengthmatters.vim
let g:lengthmatters_excluded = ['unite', 'tagbar', 'startify', 'gundo',
      \ 'vimshell', 'w3m', 'nerdtree', 'help', 'qf', 'dirvish', 'markdown',
      \ 'tex', 'conjure-log-[0-9]\+\.cljc']

" telescope.nvim
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>


" deoplete.nvim
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('keyword_patterns', {
      \ 'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'
      \ })
inoremap <silent><expr> <S-TAB>  pumvisible() ? "\<Up>" : "\<TAB>"
inoremap <silent><expr> <TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" ale
let g:ale_lint_on_text_changed = 1
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1

" deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/'

" LSP
lua << EOF

local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')

lspconfig.clangd.setup{}
lspconfig.clojure_lsp.setup{}
lspconfig.nimls.setup{}
lspconfig.zls.setup{}
lspconfig.hls.setup{}

EOF

" markdown preview
" let g:mkdp_browser = 'brave'
" nnoremap <localleader> pv MarkdownPreview()
" Others
" Tabbing
set tabstop=2 shiftwidth=2 expandtab
" Line number
set number
