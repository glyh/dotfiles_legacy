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
      },
      frecency = {
        ignore_patterns = {'/run/*/firenvim/*'}
      }
    }
  })
  tele.load_extension('fzf')
  tele.load_extension('frecency')
  tele.load_extension('projects')
  tele.load_extension('dap')

  -- Telescope
  vim.api.nvim_set_keymap(
    'n', '<leader>ff', '<cmd>Telescope find_files<CR>', {noremap = true})
  vim.api.nvim_set_keymap(
    'n', '<leader>fr', '<cmd>Telescope frecency<CR>', {noremap = true})
  vim.api.nvim_set_keymap(
    'n', '<leader>fb', '<cmd>Telescope buffers<CR>', {noremap = true})
  vim.api.nvim_set_keymap(
    'n', '<leader>r', '<cmd>Telescope projects<CR>', {noremap = true})
  vim.api.nvim_set_keymap(
    'n', 'gr', '<cmd>Telescope lsp_references<CR>', {noremap = true})
end
