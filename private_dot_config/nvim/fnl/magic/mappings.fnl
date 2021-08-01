(module magic.mappings
  {autoload       {nvim   aniseed.nvim
                   utils  magic.utils}
   require-macros [magic.macros]})


;; Vim Mappings


(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")

(utils.keymap
 :i "<TAB>"
 (fn [] (if (= 1 (nvim.fn.pumvisible)) "<Down>" "<TAB>"))
 {:noremap true :silent true :expr true} "smart_tab_tab")

(utils.keymap
 :i "<S-TAB>"
 (fn [] (if (= 1 (nvim.fn.pumvisible)) "<Up>" "<TAB>"))
 {:noremap true :silent true :expr true} "smart_tab_shift_tab")

(utils.keymap
 :i "<CR>"
 (fn [] (if (= 1 (nvim.fn.pumvisible)) "<C-y>" "<C-g>u<CR>"))
 {:noremap true :expr true} "smart_tab_enter")

(utils.keymap
 :n "<leader>ff"
 "<cmd>Telescope find_files<CR>" {}
 "telescope_find_files" "Files" "Find files in current directory.")

(utils.keymap
 :n "<leader>fp"
 "<cmd>Telescope mapper<CR>" {}
 "telescope_mapper" "Mappings" "Show key mappings.")

(utils.keymap
 :n "<leader>fr"
 "<cmd>Telescope frecency<CR>" {}
 "telescope_mru" "Files" "Find recent files.")

(utils.keymap
  :n "<leader>pu"
  "<cmd>PackerSync<CR>" {}
  "packer_sync" "Plugins" "Update plugins, then compile packer.")

(utils.keymap
  :n "gb"
  "<cmd>Telescope buffers<CR>" {}
  "telescope_buffer" "Buffers" "Switching buffers")

;; (utils.keymap
;;   :n "gh"
;;   "<cmd>Lspsaga lsp_finder<CR>" {:silent true}
;;   "lsp_finder" "LSP" "Show LSP finder.")
;;
;; (utils.keymap
;;   :n "K"
;;   "<cmd>Lspsaga hover_doc<CR>" {:silent true}
;;   "lsp_hover_doc" "LSP" "Show document under cursor")


;; Sexp Mappings

;;(set nvim.g.sexp_enable_insert_mode_mappings false)
;;(set nvim.g.sexp_filetypes "*")
;;()
