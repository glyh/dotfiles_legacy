
call plug#begin('~/.vim/plugged')

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
Plug 'Shougo/denite.nvim' " fzf
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocomplete
Plug 'deoplete-plugins/deoplete-lsp' " LSP integration with deoplete
Plug 'dense-analysis/ale' " linter
Plug 'Shougo/defx.nvim' " filer
Plug 'neovim/nvim-lspconfig'

" Lang#Clojure
Plug 'Olical/conjure' " REPL integration

" Lang#C/Cpp
Plug 'bfrg/vim-cpp-modern' " Highlight
Plug 'deoplete-plugins/deoplete-clang'

" Lang#nim
Plug 'zah/nim.vim' " Bundle


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
      \ 'vimshell', 'w3m', 'nerdtree', 'help', 'qf', 'dirvish', '.\+\.md',
      \ 'conjure-log-[0-9]\+\.cljc']

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
" let g:ale_linters = {
"      \ 'clojure': ['clj-kondo'],
"      \ 'c' : ['clang-tidy'],
"      \ 'cpp' : ['clang-tidy']
"      \}
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1

let g:LanguageClient_serverCommands = {
      \ 'clojure': ['clojure-lsp'],
      \ 'c' : ['clangd'],
      \ 'cpp' : ['clangd'],
      \ 'nim' : ['nim-lsp']
      \ }

" deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/'

" LSP
lua << EOF

require'lspconfig'.clangd.setup{}
require'lspconfig'.clojure_lsp.setup{}
require'lspconfig'.nimls.setup{}

EOF

" Others
" Tabbing
set tabstop=2 shiftwidth=2 expandtab
" Line number
set number
