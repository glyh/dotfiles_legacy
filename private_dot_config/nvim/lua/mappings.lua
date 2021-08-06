-- mappings
local mapper = require("nvim-mapper")
-- Principle: Avoid Ctrl, Meta, Esc and keys that are fucking hard to touch!

-- basics
nvim.g.mapleader = " "
nvim.g.maplocalleader = ","

mapper.map("n", "<leader>q", "<cmd>quit<CR>", {noremap = true},
  "General", "quit_shorcut", "Exit current buffer")

mapper.map("v", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_v", "Escape to normal mode")
mapper.map("x", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_x", "Escape to normal mode")
mapper.map("s", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_s", "Escape to normal mode")
mapper.map("o", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_o", "Escape to normal mode")
mapper.map("l", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_l", "Escape to normal mode")
mapper.map("c", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_c", "Escape to normal mode")
mapper.map("t", "<M-e>", "<Esc>", {noremap = true},
  "General", "escape_t", "Escape to normal mode")

mapper.map("n", ";", ":", {noremap = true},
  "General", "cmd_mode", "Go to command mode")

mapper.map("n", "<leader>w", "<C-w>w", {noremap = true},
  "General", "swith_shortcut", "Swithing around buffers")

mapper.map("n", "<leader>k", "<C-b>", {noremap = true},
  "General", "page_up", "Page up.")
mapper.map("n", "<leader>j", "<C-f>", {noremap = true},
  "General", "page_down", "Page down.")

-- Tab complete
local tab_complete = bridge(function()
  local check_back_space = function()
      local col = nvim.fn.col('.') - 1
      return col == 0 or nvim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  end
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end, "expr")
mapper.map("i", "<Tab>", tab_complete, {expr = true, noremap = true},
  "Autocomplete", "tab_complete_i", "Tab complete.")
local shift_tab_complete = bridge(function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return "<Plug>(vsnip-jump-prev)"
  else
    return "<S-Tab>"
  end
end, "expr")
mapper.map("i", "<Tab>", tab_complete, {expr = true, noremap = true},
  "Autocomplete", "tab_complete_i", "Tab complete.")
mapper.map("s", "<Tab>", tab_complete, {expr = true, noremap = true},
  "Autocomplete", "tab_complete_s", "Tab complete.")
mapper.map("i", "<S-Tab>", shift_tab_complete, {expr = true, noremap = true},
  "Autocomplete", "tab_complete_shift_tab_i", "Shift tab for smart tab.")
mapper.map("s", "<S-Tab>", shift_tab_complete, {expr = true, noremap = true},
  "Autocomplete", "tab_complete_shift_tab_s", "Shift tab for smart tab.")

-- Auto comfirm
mapper.map("i", "<CR>", "compe#confirm({ 'keys' : '<CR>', 'select' : v:true })",
  {expr=true}, "Autocomplete", "auto_confirm", "Auto confirms.")

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
--
-- mapper.map_virtual("n", "<localleader>cf", "(unknown)", {},
--   "Conjure", "conjure_connect", "Connect to backend repl from conjure.")

-- layout
mapper.map("c", "hv", "vert help", {noremap = true},
  "Layout", "help_on_right",
  "Display help on the right")
