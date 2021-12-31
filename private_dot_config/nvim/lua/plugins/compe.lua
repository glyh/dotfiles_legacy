
return function()
  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
      border = { '', '' ,'', ' ', '', '', '', ' ' },
      winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder',
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    };
    source = {
      path = true,
      buffer = true,
      nvim_lsp = true,
      nvim_lua = true,
      luasnip = true,
      conjure = true,
      neorg = true
    };
  }

  -- if vim.bo.filetype == 'norg' then
  --   require('neorg').modules.load_module('core.norg.completion')
  -- end

  -- Get the current Neorg state
  local neorg = require('neorg')

  --- Loads the Neorg completion module
  local function load_completion()
      neorg.modules.load_module("core.norg.completion", nil, {
          engine = "nvim-compe" -- Choose your completion engine here
      })
  end

  -- If Neorg is loaded already then don't hesitate and load the completion
  if neorg.is_loaded() then
    load_completion()
  else -- Otherwise wait until Neorg gets started and load the completion module then
    neorg.callbacks.on_event("core.started", load_completion)
  end
end
