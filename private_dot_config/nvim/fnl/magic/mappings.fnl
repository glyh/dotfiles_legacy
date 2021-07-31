(module magic.mappings
  {autoload {nvim aniseed.nvim
             a aniseed.core}})

(defn- termcode [str]
  (vim.api.nvim_replace_termcodes str true true true))

(def- keymap
  (do
    (var id 1)
    (fn [mode from action options]
      "Sets a key mapping."
      (if (a.string? action)
        (nvim.set_keymap mode from action options)
        (do
          (let [to (.. "keymap_fn_" id)]
            (nvim.set_keymap mode from (.. "v:lua." to "()") options)
            (tset _G to action))
          (set id (+ id 1)))))))

(defn- keymaps [configs]
  "Set key mappings"
  (each [mode mode-map (pairs configs)]
    (each [from [action config] (pairs mode-map)]
      (keymap mode from action config))))

(defn init []
  (set nvim.g.mapleader " ")
  (set nvim.g.maplocalleader "\\")
  (keymaps
    {:i
     {"<S-TAB>"
        [(fn [] (termcode (if (= 1 (nvim.fn.pumvisible)) "<Up>" "<TAB>")))
         {:noremap true :silent true :expr true}]
      "<TAB>"
        [(fn [] (termcode (if (= 1 (nvim.fn.pumvisible)) "<Down>" "<TAB>")))
         {:noremap true :silent true :expr true}]
      "<CR>"
        [(fn [] (termcode (if (= 1 (nvim.fn.pumvisible)) "<C-y>" "<C-g>u<CR>")))
         {:noremap true :expr true}]}}))
