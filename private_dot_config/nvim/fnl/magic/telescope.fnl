(module magic.telescope
  {autoload       {nvim          aniseed.nvim
                   utils         magic.utils
                   tele          telescope
                   builtin       telescope.builtin
                   actions       telescope.actions
                   actions-state telescope.actions.state
                   mapper nvim-mapper}
   require-macros [magic.macros]})


(tele.load_extension "frecency")
(tele.load_extension "mapper")
(tele.setup {:pickers {:buffers {:theme :dropdown :previewer false}} })

(mapper.setup {:no_map true})
;builtin.quickfix
;(tele.extensions.mapper.mapper {})

;; (tele.setup
;;   {:extensions
;;    {:nvim-mapper
;;     {:mappings
;;      {:n
;;       {"<cr>"
;;        (+ actions.select_default
;;           actions.center
;;           (utils.f->action
;;             (fn []
;;               (let [{:cmd cmd} (actions-state.get_selected_entry)]
;;                 (print cmd)))))}}}}})
