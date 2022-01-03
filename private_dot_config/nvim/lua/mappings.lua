local utils = require('utils')
local api, cmd = utils.api, vim.cmd
local fmt = string.format

-- Some general mappings
-- Principle: Avoid Ctrl, Meta, Esc and keys that are fucking hard to touch!

-- Layout
vim.api.nvim_set_keymap('c', 'hv', 'vert help', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>s', '<cmd>split<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>vsplit<CR>', {noremap = true})

-- Navigation
vim.api.nvim_set_keymap('n', '<leader>j', '<C-f>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>k', '<C-b>', {noremap = true})

for fr, to in pairs({h = 'h', j = 'j', k = 'k', l = 'l'}) do
  vim.api.nvim_set_keymap('t', fmt('<A-%s>', fr), fmt([[<C-\><C-N><C-w>%s]], to), {noremap = true})
  vim.api.nvim_set_keymap('n', fmt('<A-%s>', fr), fmt([[<C-w>%s]], to), {noremap = true})
end

-- Quit
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>qa<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>q<CR>', {noremap = true})

-- Normal
-- In case arpeggio is not installed
-- Conflicts with luasnip in visual select mode
cmd([[
  try
    call arpeggio#map('i', '', 0, 'jk', '<Esc>')
  catch
  endtry
]])

-- Terminal
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {noremap = true})

-- Command
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})

-- -- Translate
-- nvim.vim.api.nvim_set_keymap('n', 't', bridge(function()
--   local word = nvim.fn.expand('<cword>')
--   local Job = require('plenary.job')
--   local Str = require('plenary.strings')
--   local output = ""
--   Job:new({
--     command = "trans",
--     args = {"-t", HOME_LANG, word},
--     on_stdout = vim.schedule_wrap(function(_, data)
--       if data ~= nil then
--         output = output .. data
--       end
--     end),
--     on_exit = vim.schedule_wrap(function(_, return_val)
--       if return_val == 0 then
--         local lines = split(output, "\n")
--         local width = 0
--         for k, v in ipairs(lines) do
--           local cur_width = Str.strdisplaywidth(v)
--           if cur_width > width then
--             width = cur_width
--           end
--           lines[k] = lines[k] -- .. "\x1B"
--         end
--         vim.cmd('vsplit')
--         local win = vim.api.nvim_get_current_win()
--         local buf = vim.api.nvim_create_buf(true, true)
--         nvim.api.win_set_buf(win, buf)
--         nvim.api.buf_set_lines(buf, 0, -1, false, lines)
--         vim.cmd('AnsiEsc')
--       end
--     end)
--   }):start()
-- end, 'cmd_keys'), {noremap = true})
--
-- nvim.vim.api.nvim_set_keymap('v', 't', bridge(function()
--   local selection = get_selection()
--   require('plenary.async').run(function()
--     vim.cmd(string.format([[
--       Nredir !trans -t %s %s
--     ]], HOME_LANG, selection))
--   end)
-- end, 'cmd_keys'), {noremap = true})
