_G.nvim = setmetatable({
    api = setmetatable({}, {
      __index = function(_, k)
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

function _G.bridge(f, category)
  if BRIDGE_ID == nil then
    BRIDGE_ID = 1
  else
    BRIDGE_ID = BRIDGE_ID + 1
  end
  local id_gen = "lua_bridge_function" .. BRIDGE_ID
  local result

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
    endfunction ]], BRIDGE_ID, id_gen), true)
    result = "VimFunctionBridge" .. BRIDGE_ID
  elseif category == "op" then
    nvim.cmd(string.format([[ function!VimFunctionBridge%d(type = '')
      if a:type == ''
        set opfunc=VimFunctionBridge%d
        return 'g@'
      end
      return luaeval("%s(_A[1])", [a:type])
    endfunction ]], BRIDGE_ID, BRIDGE_ID, id_gen))
    result = "VimFunctionBridge" .. BRIDGE_ID .. "()"
  end
  _G[id_gen] = f
  return result
end

function _G.augroup(group_name, definition)
  nvim.api.command("augroup " .. group_name)
  nvim.api.command("autocmd!")
  for _, def in ipairs(definition) do
    if type(def) == "table" and type(def[#def]) == "function" then
      def[#def] = bridge(def[#def], "cmd")
    end
    local command = table.concat(nvim.tbl_flatten{"autocmd", def}, " ")
    nvim.api.command(command)
  end
  nvim.api.command("augroup end")
end

-- Bootstrapping

local pack_path = nvim.fn.stdpath("data") .. "/site/pack"

function _G.ensure(user, repo)
  -- Ensures a given github.com/user/repo is cloned in the
  -- Pack/packer/start directory.
  local install_path =
  string.format("%s/packer/start/%s", pack_path, repo, repo)
  if nvim.fn.empty(nvim.fn.glob(install_path)) > 0 then
    nvim.cmd(string.format("!git clone https://" .. _G.GITHUB_CDN .. "/%s/%s %s",
    user, repo, install_path))
    nvim.cmd(string.format("packadd %s", repo))
  end
end

function _G.prequire(name)
  local ok, module = pcall(require, name)
  return ok and module or nil
end
