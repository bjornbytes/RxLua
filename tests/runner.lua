lust = require 'tests/lust'
Rx = require 'rx'

for _, fn in pairs({'describe', 'it', 'test', 'expect', 'spy', 'before', 'after'}) do
  _G[fn] = lust[fn]
end

observableSpy = function(observable)
  local observer = Rx.Observer.create(_, function() end, _)
  local onNext = spy(observer, '_onNext')
  local onError = spy(observer, '_onError')
  local onCompleted = spy(observer, '_onCompleted')
  observable:subscribe(observer)
  return onNext, onError, onCompleted
end

lust.paths['produce'] = {
  'nothing',
  f = function(observable, ...)
    local args = {...}
    local values
    if type(args[1]) ~= 'table' then
      values = {}
      for i = 1, math.max(#args, 1) do
        table.insert(values, {args[i]})
      end
    else
      values = args[1]
    end

    local onNext, onError, onCompleted = observableSpy(observable)
    expect(observable).to.be.an(Rx.Observable)
    expect(onNext).to.equal(values)
    expect(#onError).to.equal(0)
    expect(#onCompleted).to.equal(1)
    return true
  end
}

lust.paths['nothing'] = {
  f = function(observable)
    local onNext, onError, onCompleted = observableSpy(observable)
    expect(observable).to.be.an(Rx.Observable)
    expect(#onNext).to.equal(0)
    expect(#onError).to.equal(0)
    expect(#onCompleted).to.equal(1)
    return true
  end
}

table.insert(lust.paths['to'], 'produce')

if arg[1] then
  arg[1] = arg[1]:gsub('^(tests/)', ''):gsub('%.lua$', '')
  dofile('tests/' .. arg[1] .. '.lua')
else
  local files = {
    'observer',
    'observable',
    'subscription',
    'subject',
    'asyncsubject',
    'behaviorsubject',
    'replaysubject'
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
