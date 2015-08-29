lust = require 'tests/lust'
Rx = require 'rx'

for _, fn in pairs({'describe', 'it', 'test', 'expect', 'spy'}) do
  _G[fn] = lust[fn]
end

if arg[1] then
  arg[1] = arg[1]:gsub('^(tests/).+', ''):gsub('%.lua$', '')
  return dofile('tests/' .. arg[1] .. '.lua')
end

local files = {
  'observer'
}

for i, file in ipairs(files) do
  dofile('tests/' .. file .. '.lua')
  if next(files, i) then
    print()
  end
end

if lust.errors > 0 then os.exit(1) end
