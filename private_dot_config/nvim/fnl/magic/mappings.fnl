(module magic.mappings
  {autoload       {a      aniseed.core
                   nvim   aniseed.nvim
                   utils  magic.utils
                   meta   magic.meta}
   require-macros [magic.macros]})


;; Basics

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")


;; Smart Tabs

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


;; Telescopes

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


;; Conjure

(global conjure_mappings (fn []
  (utils.keymap
    :n "<localleader>lx"
    (fn []
      (let [re (vim.regex "conjure-log-[0-9]\\+\\.[a-zA-Z0-9]\\+$")]
        (if (a.reduce
             (fn [acc win]
               (let [buf-name (nvim.buf_get_name (nvim.win_get_buf win))
                     win-conf (nvim.win_get_config win)]
                 (or (and (: re :match_str buf-name)
                          (. win-conf :focusable))
                     acc)))
             false
             (nvim.tabpage_list_wins 0))
          "<localleader>lq"
          "<localleader>lv")))
    {:expr true} "conjure_log_toggle" "Conjure"
    "Toggle conjure buffer on the left.")
  (utils.keymap-doc
    :n "<localleader>cf"
    "conjure_connect" "Conjure" "Connect to backend REPL from Conjure.")))

(augroup conjure-mappings-augroup
  (nvim.ex.autocmd
    :FileType meta.lisp-file-types
    "call v:lua.conjure_mappings()"))


;; (utils.keymap
;;   :n "gh"
;;   "<cmd>Lspsaga lsp_finder<CR>" {:silent true}
;;   "lsp_finder" "LSP" "Show LSP finder.")
;;
;; (utils.keymap
;;   :n "K"
;;   "<cmd>Lspsaga hover_doc<CR>" {:silent true}
;;   "lsp_hover_doc" "LSP" "Show document under cursor")
