-- mappings
local mapper = require("nvim-mapper")
-- Principle: Avoid Ctrl, Meta, Esc and keys that are fucking hard to touch!

-- basics
nvim.g.mapleader = " "
nvim.g.maplocalleader = ","

mapper.map("n", "<leader>q", "<cmd>qa<CR>", {noremap = true},
  "General", "quit_all_shorcut", "Exit vim.")
mapper.map("n", "<leader>v", "<cmd>vsplit<CR>", {noremap = true},
  "General", "quit_new_vsplit", "New vertical split.")
mapper.map("n", "<localleader>q", "<cmd>q<CR>", {noremap = true},
  "General", "quit_shorcut", "Exit current buffer.")

nvim.cmd([[
  call arpeggio#map('i', '', 0, 'jk', '<Esc>')
  call arpeggio#map('v', '', 0, 'jk', '<Esc>')
  call arpeggio#map('o', '', 0, 'jk', '<Esc>')
  call arpeggio#map('c', '', 0, 'jk', '<Esc>')
  call arpeggio#map('l', '', 0, 'jk', '<Esc>')
  call arpeggio#map('t', '', 0, 'jk', '<Esc>')
  call arpeggio#map('x', '', 0, 'jk', '<Esc>')
]])

mapper.map("n", ";", ":", {noremap = true},
  "General", "cmd_mode", "Go to command mode")

mapper.map("n", "<leader>w", "<C-w>w", {noremap = true},
  "General", "swith_shortcut", "Swithing around buffers")

mapper.map("n", "<leader>k", "<C-b>", {noremap = true},
  "General", "page_up", "Page up.")
mapper.map("n", "<leader>j", "<C-f>", {noremap = true},
  "General", "page_down", "Page down.")

-- Tab complete

mapper.map("i", "<Tab>", bridge(function()
  if nvim.fn.pumvisible() == 1 then
    return "<Down>"
  else
    return "<TAB>"
  end
end, "expr"), {expr = true, noremap = true},
  "Autocomplete", "tab_complete_i", "Tab complete.")
mapper.map("i", "<S-Tab>", bridge(function()
  if nvim.fn.pumvisible() == 1 then
    return "<Up>"
  else
    return "<S-TAB>"
  end
end, "expr"), {expr = true, noremap = true},
  "Autocomplete", "shift_tab_complete_i", "Shift tab complete.")
-- mapper.map("i", "<Tab>", tab_complete, {expr = true, noremap = true},
--   "Autocomplete", "tab_complete_i", "Tab complete.")
-- mapper.map("s", "<Tab>", tab_complete, {expr = true, noremap = true},
--   "Autocomplete", "tab_complete_s", "Tab complete.")
-- mapper.map("i", "<S-Tab>", shift_tab_complete, {expr = true, noremap = true},
--   "Autocomplete", "tab_complete_shift_tab_i", "Shift tab for smart tab.")
-- mapper.map("s", "<S-Tab>", shift_tab_complete, {expr = true, noremap = true},
--   "Autocomplete", "tab_complete_shift_tab_s", "Shift tab for smart tab.")

-- Auto comfirm
-- mapper.map("i", "<CR>", "compe#confirm({ 'keys' : '<CR>', 'select' : v:true })",
--  {expr=true}, "Autocomplete", "auto_confirm", "Auto confirms.")

-- telescopes
mapper.map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {noremap = true},
  "Files", "telescope_find_files", "Find files in current directory.")

mapper.map("n", "<leader>fr", "<cmd>Telescope frecency<CR>", {noremap = true},
  "Files", "telescope_mru", "Find recent files.")

mapper.map("n", "<leader>fp", "<cmd>Telescope mapper<CR>", {noremap = true},
  "Mappings", "telescope_mapper", "Show key mappings.")

mapper.map("n", "gb", "<cmd>Telescope buffers<CR>", {noremap = true},
  "Buffers", "telescope_buffer", "Switching buffers.")

-- packer
mapper.map("n", "<leader>pu", "<cmd>PackerSync<CR>", {noremap = true},
  "Plugins", "packer_sync", "Update plugins, then compile packer.")

mapper.map("n", "<leader>ps", "<cmd>PackerStatus<CR>", {noremap = true},
  "Plugins", "packer_status", "Show plugin status.")

-- conjure
mapper.map("n", "<localleader>ll", bridge(function()
    local re = nvim.regex("conjure-log-[0-9]\\+\\.[a-z]\\+$")
    for _, win in ipairs(nvim.api.tabpage_list_wins(0)) do
      if re:match_str(nvim.api.buf_get_name(nvim.api.win_get_buf(win)))
        and nvim.api.win_get_config(win).focusable then
        nvim.cmd("ConjureLogCloseVisible")
        return
      end
    end
    nvim.cmd("ConjureLogVSplit")
  end, "cmd_keys"), {noremap = true},
  "Conjure", "conjure_log_toggle", "Toggle conjure buffer to side.")

-- easymotion
mapper.map("", "<leader>l", "<Plug>(easymotion-bd-jk)", {},
  "Easymotion", "easymotion_bd_jk", "Find a line")
mapper.map("n", "<leader>l", "<Plug>(easymotion-overwin-line)", {},
  "Easymotion", "easymotion_overwin_line", "Find a line over windows")
mapper.map("", "<leader>f", "<Plug>(easymotion-bd-f2)", {},
  "Easymotion", "easymotion_bd_f2", "Find two chars")
mapper.map("n", "<leader>f", "<Plug>(easymotion-overwin-f2)", {},
  "Easymotion", "easymotion_overwin_f2", "Find two chars over windows")

-- layout
mapper.map("c", "hv", "vert help", {noremap = true},
  "Layout", "help_on_right",
  "Display help on the right")
