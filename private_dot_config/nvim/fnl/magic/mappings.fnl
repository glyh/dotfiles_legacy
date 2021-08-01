(module magic.mappings
  {autoload       {nvim   aniseed.nvim
                   tele   telescope
                   utils  magic.utils}
   require-macros [magic.macros]})


;; Mapper & Vim Mappings


(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader "\\")
(utils.keymaps
  {:i
   {"<TAB>"
    [(fn [] (utils.termcode
             (if (= 1 (nvim.fn.pumvisible)) "<Down>" "<TAB>")))
     {:noremap true :silent true :expr true}]

    "<S-TAB>"
    [(fn [] (utils.termcode
             (if (= 1 (nvim.fn.pumvisible)) "<Up>" "<TAB>")))
     {:noremap true :silent true :expr true}]

    "<CR>"
    [(fn [] (utils.termcode
             (if (= 1 (nvim.fn.pumvisible)) "<C-y>" "<C-g>u<CR>")))
     {:noremap true :expr true}]}


   :n
   {"<leader>ff"
    ["<cmd>Telescope find_files<CR>" {}
     "Files" "telescope-find-files" "Find files in current directory."]

    "<leader>fp"
    ["<cmd>Telescope mapper<CR>" {}
     "Mappings" "mapper-show-mappings" "Show key mappings."]

    "<leader>fr"
    ["<cmd>Telescope frecency<CR>" {}
     "Files" "telescope-mru" "Find recent files."]

    "<leader>pu"
    ["<cmd>PackerSync<CR>" {}
     "Plugins" "packer-sync" "Update plugins."]
    "gd"
    [vim.lsp.buf.definition {}
     "LSP" "lsp-definition" "Go to definition."]
    "gr"
    ["<cmd>Telescope lsp_references previewer=false theme=get_ivy<CR>" {}
     "LSP" "lsp-references" "Go to references."]}})
