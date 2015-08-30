lust = require 'tests/lust'
Rx = require 'rx'

for _, fn in pairs({'describe', 'it', 'test', 'expect', 'spy', 'before', 'after'}) do
  _G[fn] = lust[fn]
end

if arg[1] then
  arg[1] = arg[1]:gsub('^(tests/).+', ''):gsub('%.lua$', '')
  dofile('tests/' .. arg[1] .. '.lua')
else
  local files = {
    'observer'
  }

  for i, file in ipairs(files) do
    dofile('tests/' .. file .. '.lua')
    if next(files, i) then
      print()
    end
  end
end

local red = string.char(27) .. '[31m'
local green = string.char(27) .. '[32m'
local normal = string.char(27) .. '[0m'

if lust.errors > 0 then
  io.write(red .. lust.errors .. normal .. ' failed, ')
end

print(green .. lust.passes .. normal .. ' passed')

if lust.errors > 0 then os.exit(1) end
