-- lust - Lua test framework
-- https://github.com/bjornbytes/lust
-- License - MIT, see LICENSE for details.

local lust = {}
lust.level = 0
lust.passes = 0
lust.errors = 0

local red = string.char(27) .. '[31m'
local green = string.char(27) .. '[32m'
local normal = string.char(27) .. '[0m'
local function indent(level) return string.rep('\t', level or lust.level) end

function lust.describe(name, fn)
  print(indent() .. name)
  lust.level = lust.level + 1
  fn()
  lust.level = lust.level - 1
end

function lust.it(name, fn)
  if type(lust.onbefore) == 'function' then lust.onbefore(name) end
  local success, err = pcall(fn)
  if success then lust.passes = lust.passes + 1
  else lust.errors = lust.errors + 1 end
  local color = success and green or red
  local label = success and 'PASS' or 'FAIL'
  print(indent() .. color .. label .. normal .. ' ' .. name)
  if err then
    print(indent(lust.level + 1) .. red .. err .. normal)
  end
  if type(lust.onafter) == 'function' then lust.onafter(name) end
end

function lust.before(fn)
  assert(fn == nil or type(fn) == 'function', 'Must pass nil or a function to lust.before')
  lust.onbefore = fn
end

function lust.after(fn)
  assert(fn == nil or type(fn) == 'function', 'Must pass nil or a function to lust.after')
  lust.onafter = fn
end

-- Assertions
local function isa(v, x)
  if type(x) == 'string' then return type(v) == x, tostring(v) .. ' is not a ' .. x
  elseif type(x) == 'table' then
    if type(v) ~= 'table' then return false, tostring(v) .. ' is not a ' .. tostring(x) end
    local seen = {}
    local meta = v
    while meta and not seen[meta] do
      if meta == x then return true end
      seen[meta] = true
      meta = getmetatable(meta) and getmetatable(meta).__index
    end
    return false, tostring(v) .. ' is not a ' .. tostring(x)
  end
  return false, 'invalid type ' .. tostring(x)
end

local function has(t, x)
  for k, v in pairs(t) do
    if v == x then return true end
  end
  return false
end

local function strict_eq(t1, t2)
  if type(t1) ~= type(t2) then return false end
  if type(t1) ~= 'table' then return t1 == t2 end
  if #t1 ~= #t2 then return false end
  for k, _ in pairs(t1) do
    if not strict_eq(t1[k], t2[k]) then return false end
  end
  for k, _ in pairs(t2) do
    if not strict_eq(t2[k], t1[k]) then return false end
  end
  return true
end

local paths = {
  [''] = {'to', 'to_not'},
  to = {'have', 'equal', 'be', 'exist', 'fail'},
  to_not = {'have', 'equal', 'be', 'exist', 'fail', chain = function(a) a.negate = not a.negate end},
  be = {'a', 'an', 'truthy', 'falsy', f = function(v, x)
    return v == x, tostring(v) .. ' and ' .. tostring(x) .. ' are not equal'
  end},
  a = {f = isa},
  an = {f = isa},
  exist = {f = function(v) return v ~= nil, tostring(v) .. ' is nil' end},
  truthy = {f = function(v) return v, tostring(v) .. ' is not truthy' end},
  falsy = {f = function(v) return not v, tostring(v) .. ' is not falsy' end},
  equal = {f = function(v, x) return strict_eq(v, x), tostring(v) .. ' and ' .. tostring(x) .. ' are not strictly equal' end},
  have = {
    f = function(v, x)
      if type(v) ~= 'table' then return false, 'table "' .. tostring(v) .. '" is not a table' end
      return has(v, x), 'table "' .. tostring(v) .. '" does not have ' .. tostring(x)
    end
  },
  fail = {f = function(v) return not pcall(v), tostring(v) .. ' did not fail' end}
}

function lust.expect(v)
  local assertion = {}
  assertion.val = v
  assertion.action = ''
  assertion.negate = false

  setmetatable(assertion, {
    __index = function(t, k)
      if has(paths[rawget(t, 'action')], k) then
        rawset(t, 'action', k)
        local chain = paths[rawget(t, 'action')].chain
        if chain then chain(t) end
        return t
      end
      return rawget(t, k)
    end,
    __call = function(t, ...)
      if paths[t.action].f then
        local res, err = paths[t.action].f(t.val, ...)
        if assertion.negate then res = not res end
        if not res then
          error(err or 'unknown failure', 2)
        end
      end
    end
  })

  return assertion
end

function lust.spy(target, name, run)
  local spy = {}
  local subject

  local function capture(...)
    table.insert(spy, {...})
    return subject(...)
  end

  if type(target) == 'table' then
    subject = target[name]
    target[name] = capture
  else
    run = name
    subject = target or function() end
  end

  setmetatable(spy, {__call = function(_, ...) return capture(...) end})

  if run then run() end

  return spy
end

lust.test = lust.it
lust.paths = paths

return lust
