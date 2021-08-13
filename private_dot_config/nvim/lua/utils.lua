local utils = {}

utils.nvim = setmetatable({
    api = setmetatable({}, {
      __index = function(t, k)
        return vim.api["nvim_" .. k]
      end
    }),
    v = setmetatable({}, {
      __index = function(_, k)
        return vim.api.nvim_get_vvar(k)
      end,
      __newindex = function(_, k, v)
        return vim.api.nvim_set_vvar(k, v)
      end
  })
  }, {
    __index = function(nvim, k)
      if k ~= "api" and k ~= "v" then
        return vim[k]
      else
        return nvim[k]
      end
    end
  })

function utils.bridge(f, category)
  if bridge_id == nil then
    bridge_id = 1
  else
    bridge_id = bridge_id + 1
  end
  local id_gen = "lua_bridge_function" .. bridge_id
  local result = result

  if category == "expr" then
    local f_origin = f
    f = function(...)
      return nvim.api.replace_termcodes(f_origin(...), true, true, true)
    end
    result = "v:lua." .. id_gen .. "()"
  elseif category == "cmd" then
    result = "lua " .. id_gen .. "()"
  elseif category == "cmd_keys" then
    result = "<cmd> lua " .. id_gen .. "()<CR>"
  elseif category == "vim_func" then
    nvim.cmd.exec(string.format([[ function! VimFunctionBridge%d(...)
      " Passing on varargs
      return luaeval("%s(unpack(_A))", a:000)
    endfunction ]], bridge_id, id_gen), true)
    result = "VimFunctionBridge" .. bridge_id
  elseif category == "op" then
    nvim.cmd(string.format([[ function!VimFunctionBridge%d(type = '')
      if a:type == ''
        set opfunc=VimFunctionBridge%d
        return 'g@'
      end
      return luaeval("%s(_A[1])", [a:type])
    endfunction ]], bridge_id, bridge_id, id_gen))
    result = "VimFunctionBridge" .. bridge_id .. "()"
  end
  _G[id_gen] = f
  return result
end

function utils.augroup(group_name, definition)
  nvim.api.command("augroup " .. group_name)
  nvim.api.command("autocmd!")
  for _, def in ipairs(definition) do
    if type(def) == "table" and type(def[#def]) == "function" then
      def[#def] = utils.bridge(def[#def], "cmd")
    end
    local command = table.concat(vim.tbl_flatten{"autocmd", def}, " ")
    nvim.api.command(command)
  end
  nvim.api.command("augroup end")
end

return utils
