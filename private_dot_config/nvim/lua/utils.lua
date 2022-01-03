-- Any use associated with _G is deprecated
-- _G.nvim = setmetatable({
--     api = setmetatable({}, {
--       __index = function(_, k)
--         return vim.api['nvim_' .. k]
--       end
--     }),
--   }, {
--     __index = function(nvim, k)
--       if k ~= 'api' then
--         return vim[k]
--       else
--         return nvim[k]
--       end
--     end
--   })
-- _G.nv = _G.nvim

-- mapping

local _M = {}
-- _M.api = setmetatable({}, {
--   __index = function(_, k)
--     return vim.api['nvim_' .. k]
--   end
-- })
function _M.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- lua & vim interop

function _M.bridge(f, category)
  if BRIDGE_ID == nil then
    BRIDGE_ID = 1
  else
    BRIDGE_ID = BRIDGE_ID + 1
  end
  local id_gen = 'lua_bridge_function' .. BRIDGE_ID
  _G[id_gen] = f
  if category == 'expr' then
    return 'v:lua.' .. id_gen .. '()'
  elseif category == 'cmd' then
    return 'lua ' .. id_gen .. '()'
  elseif category == 'cmd_keys' then
    return '<cmd> lua ' .. id_gen .. '()<CR>'
  elseif category == 'vim_func' then
    vim.cmd.exec(string.format([[ function! VimFunctionBridge%d(...)
      ' Passing on varargs
      return luaeval('%s(unpack(_A))', a:000)
    endfunction ]], BRIDGE_ID, id_gen), true)
    return 'VimFunctionBridge' .. BRIDGE_ID
  elseif category == 'op' then
    vim.cmd(string.format([[ function! VimFunctionBridge%d(type = '')
      if a:type == ''
        set opfunc=VimFunctionBridge%d
        return 'g@'
      end
      return luaeval('%s(_A[1])', [a:type])
    endfunction ]], BRIDGE_ID, BRIDGE_ID, id_gen))
    return 'VimFunctionBridge' .. BRIDGE_ID .. '()'
  end
end

function _M.augroup(group_name, definition)
  vim.cmd('augroup ' .. group_name)
  --print('augroup' .. group_name)
  vim.cmd('autocmd!')
  --print('autocmd!')
  for _, def in ipairs(definition) do
    if type(def) == 'table' and type(def[#def]) == 'function' then
      def[#def] = _M.bridge(def[#def], 'cmd')
    end
    local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
    -- FIXME: This might be a bug, what the hell is tbl_flatten?
    vim.cmd(command)
    --print(command)
  end
  vim.cmd('augroup end')
  --print('augroup end')
end

-- Bootstrapping

local pack_path = vim.fn.stdpath('data') .. '/site/pack'

function _M.ensure(user, repo)
  -- Ensures a given github.com/user/repo is cloned in the
  -- Pack/packer/start directory.
  local install_path =
  string.format('%s/packer/start/%s', pack_path, repo, repo)
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd(
      string.format('!git clone https://' .. _G.GITHUB_CDN .. '/%s/%s %s',
      user, repo, install_path))
    vim.cmd(string.format('packadd %s', repo))
  end
end

function _M.prequire(name)
  local ok, module = pcall(require, name)
  return ok and module or nil
end

function _M.get_selection()
  -- does not handle rectangular selection
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

function _M.split(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for s in string.gmatch(str, "([^"..sep.."]+)") do
    --print(string.byte(s))
    table.insert(t, s)
  end
  return t
end

function _M.array_concat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-- for k, v in pairs(_M) do
--   _G[k] = v
-- end

return _M
