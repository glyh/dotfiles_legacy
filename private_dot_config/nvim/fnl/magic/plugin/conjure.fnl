(module magic.plugin.conjure
  {autoload {nvim aniseed.nvim}})

(set nvim.g.conjure#log#hud#width 1)
(set nvim.g.conjure#log#hud#anchor :SE)
(set nvim.g.conjure#log#hud#border :none)
(set nvim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")
;;let g:conjure#client#fennel#aniseed#aniseed_module_prefix = "aniseed."
;;set completeopt-=preview
