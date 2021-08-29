local mapper = prequire('nvim-mapper')
if not mapper then
  return
end

-- Principle: Avoid Ctrl, Meta, Esc and keys that are fucking hard to touch!

-- basics
nvim.g.mapleader = ' '
nvim.g.maplocalleader = ','

mapper.map('n', '<leader>e', '<cmd>qa<CR>', {noremap = true},
  'General', 'quit_all_shorcut', 'Exit vim.')
mapper.map('n', '<leader>s', '<cmd>split<CR>', {noremap = true},
  'General', 'quit_new_hsplit', 'New horizontal split.')
mapper.map('n', '<leader>v', '<cmd>vsplit<CR>', {noremap = true},
  'General', 'quit_new_vsplit', 'New vertical split.')
mapper.map('n', '<leader>q', '<cmd>q<CR>', {noremap = true},
  'General', 'quit_shorcut', 'Exit current buffer.')

-- In case arpeggio is not installed
-- Conflicts with luasnip in visual select mode
nvim.cmd([[
  try
    call arpeggio#map('i', '', 0, 'jk', '<Esc>')
  catch
  endtry
]])

mapper.map('n', ';', ':', {noremap = true},
  'General', 'cmd_mode', 'Go to command mode')

mapper.map('n', '<leader>w', '<Plug>(choosewin)', {},
  'General', 'swith_shortcut', 'Swithing around windows.')

mapper.map('n', '<leader>k', '<C-b>', {noremap = true},
  'General', 'page_up', 'Page up.')
mapper.map('n', '<leader>j', '<C-f>', {noremap = true},
  'General', 'page_down', 'Page down.')

-- Tab complete & snippet complete

local function tab_complete() -- _G.tab_complete = function()
    local luasnip = require('luasnip')
    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
    end
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif luasnip and luasnip.expand_or_jumpable() then
        return t "<Plug>luasnip-expand-or-jump"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']() --!!!
    end
end

local function s_tab_complete() -- _G.s_tab_complete = function()
    local luasnip = require('luasnip')
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
    elseif luasnip and luasnip.jumpable(-1) then
      return t "<Plug>luasnip-jump-prev"
    else
      return t "<S-Tab>"
    end
end

mapper.map('i', '<Tab>', bridge(tab_complete, 'expr'),
  {expr = true},
  'Autocomplete', 'autocomplete_i_tab', 'Tab key for auto complete.')
mapper.map('s', '<Tab>', bridge(tab_complete, 'expr'),
  {expr = true},
  'Autocomplete', 'autocomplete_s_tab', 'Tab key for auto complete.')
mapper.map('i', '<S-Tab>', bridge(s_tab_complete, 'expr'),
  {expr = true}, 'Autocomplete', 'autocomplete_i_shift_tab',
  'Shift-tab key for auto complete.')
mapper.map('s', '<S-Tab>', bridge(s_tab_complete, 'expr'),
  {expr = true}, 'Autocomplete', 'autocomplete_s_shift_tab',
  'Shift-tab key for auto complete.')

-- Auto comfirm
mapper.map('i', '<CR>', "compe#confirm({ 'keys': '<CR>', 'select': v:true })",
  {noremap = true, expr = true}, 'Autocomplete', 'autocomplete_confirm',
  'Confirm key for auto complete.')

-- telescopes
mapper.map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', {noremap = true},
  'Files', 'telescope_find_files', 'Find files in current directory.')

mapper.map('n', '<leader>fr', '<cmd>Telescope frecency<CR>', {noremap = true},
  'Files', 'telescope_mru', 'Find recent files.')

mapper.map('n', '<leader>fp', '<cmd>Telescope mapper<CR>', {noremap = true},
  'Mappings', 'telescope_mapper', 'Show key mappings.')

mapper.map('n', '<leader>ft', '<cmd>TodoTelescope<CR>', {noremap = true},
  'Buffers', 'telescope_todo', 'Show all todos.')

mapper.map('n', 'gb', '<cmd>Telescope buffers<CR>', {noremap = true},
  'Buffers', 'telescope_buffer', 'Switching buffers.')



-- packer
mapper.map('n', '<leader>pu', '<cmd>PackerSync<CR>', {noremap = true},
  'Plugins', 'packer_sync', 'Update plugins, then compile packer.')

mapper.map('n', '<leader>ps', '<cmd>PackerStatus<CR>', {noremap = true},
  'Plugins', 'packer_status', 'Show plugin status.')

-- conjure
mapper.map('n', '<localleader>ll', bridge(function()
    local re = nvim.regex('conjure-log-[0-9]\\+\\.[a-z]\\+$')
    for _, win in ipairs(nvim.api.tabpage_list_wins(0)) do
      if re:match_str(nvim.api.buf_get_name(nvim.api.win_get_buf(win)))
        and nvim.api.win_get_config(win).focusable then
        nvim.cmd('ConjureLogCloseVisible')
        return
      end
    end
    nvim.cmd('ConjureLogVSplit')
  end, 'cmd_keys'), {noremap = true},
  'Conjure', 'conjure_log_toggle', 'Toggle conjure buffer to side.')

-- layout
mapper.map('c', 'hv', 'vert help', {noremap = true},
  'Layout', 'help_on_right',
  'Display help on the right')

-- lsp
mapper.map('n', 'gr', '<cmd>Telescope lsp_references<CR>', {noremap = true},
  'LSP', 'lsp_show_reference', 'Show references.')

-- Undo tree
mapper.map('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {noremap = true},
  'Undo', 'undo_tree_toggle', 'Show undo tree')

-- -- Vim sneak
-- mapper.map('', 'f', '<Plug>Sneak_s', {},
--   'Easymotion', 'small_n', 'Sneak.')
-- mapper.map('', 'F', '<Plug>Sneak_S', {},
--   'Easymotion', 'small_o', 'Sneak.')

-- -- Vim Smalls
-- mapper.map('n', 'f', '<Plug>(smalls)', {},
--   'Easymotion', 'small_n', 'Smalls.')
-- mapper.map('o', 'f', '<Plug>(smalls)', {},
--   'Easymotion', 'small_o', 'Smalls.')
-- mapper.map('x', 'f', '<Plug>(smalls)', {},
--   'Easymotion', 'small_x', 'Smalls.')

-- hop.nvim
mapper.map('n', 'f', '<cmd>HopChar2<CR>', {},
  'Easymotion', 'hop_char2_n', 'Hop.')
mapper.map('v', 'f', '<cmd>HopChar2<CR>', {},
  'Easymotion', 'hop_char2_v', 'Hop.')
mapper.map('o', 'f', '<cmd>HopChar2<CR>', {},
  'Easymotion', 'hop_char2_o', 'Hop.')
mapper.map('n', 'F',
  "<cmd>lua require('hop').hint_patterns({case_insensitive = false})<CR>", {},
  'Easymotion', 'hop_pattern_n', 'Hop.')
mapper.map('v', 'F',
  "<cmd>lua require('hop').hint_patterns({case_insensitive = false})<CR>", {},
  'Easymotion', 'hop_pattern_v', 'Hop.')
mapper.map('o', 'F',
  "<cmd>lua require('hop').hint_patterns({case_insensitive = false})<CR>", {},
  'Easymotion', 'hop_pattern_o', 'Hop.')
