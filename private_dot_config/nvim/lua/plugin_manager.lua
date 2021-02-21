local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have 
-- https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

local packer = require('packer')
packer.reset()
local use = packer.use
local use_rocks = packer.use_rocks

packer.init({
  auto_clean = false -- During sync(), remove unused plugins
})

-- Packer can manage itself as an optional plugin
use {'wbthomason/packer.nvim', opt = true}

-- UI
use 'itchyny/lightline.vim' -- statusline
use 'cocopon/iceberg.vim' -- colorscheme
use 'ncm2/float-preview.nvim' -- autocomplete float preview
use 'whatyouhide/vim-lengthmatters' -- 80 chars highlight

-- Editing
use 'tpope/vim-surround' -- surround
use 'wellle/targets.vim' -- targets
use 'jiangmiao/auto-pairs' -- autopairs
use 'easymotion/vim-easymotion' -- optimized motions
use 'guns/vim-sexp' -- s expression edit
use 'tpope/vim-sexp-mappings-for-regular-people' --sexp mappings

-- Tools
use 'airblade/vim-gitgutter' -- git status on left
use 'Shougo/denite.nvim' -- united interface
use {'Shougo/deoplete.nvim', run=':UpdateRemotePlugins'} -- autocomplete
use 'deoplete-plugins/deoplete-lsp' -- lsP integration with deoplete
use 'dense-analysis/ale' -- linter
use 'shougo/defx.nvim' --filer
use 'neovim/nvim-lspconfig' -- some out of box LSP configs

return packer
