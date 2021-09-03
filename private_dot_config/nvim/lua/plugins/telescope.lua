return function()
  local tele = require('telescope')
  tele.setup({
    pickers = {
      buffers = {
        theme = 'dropdown',
        previewer = false
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case'
      }
    }
  })
  tele.load_extension('fzf')
  tele.load_extension('frecency')
  tele.load_extension('mapper')
end
