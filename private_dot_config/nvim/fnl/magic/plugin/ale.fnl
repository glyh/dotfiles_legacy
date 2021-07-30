(module magic.plugin.ale
  {autoload {nvim aniseed.nvim}})

(set nvim.g.ale_lint_on_text_changed true)
(set nvim.g.ale_fixers {:* [:remove_trailing_lines :trim_whitespace] })
(set nvim.g.ale_fix_on_save true)
