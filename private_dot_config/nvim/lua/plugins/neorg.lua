return function()
  require('neorg').setup({
    load = {
      ['core.defaults'] = {
        config = {
          disable = (function()
            if prequire('compe') then
              return {}
            else
              return { 'core.norg.completion' }
            end
          end)()
        }
      },
      ['core.keybinds'] = {
        config = {
          default_keybinds = true
        }
      },
      ['core.norg.concealer'] = {}, -- Allows for use of icons
      ['core.norg.dirman'] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            my_workspace = '~/neorg'
          }
        }
      },
    }
  })
end
