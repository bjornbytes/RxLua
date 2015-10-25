local Rx = require 'rx'
local scheduler = Rx.CooperativeScheduler.create()

-- Cheer someone on using functional reactive programming

local observable = Rx.Observable.fromCoroutine(function()
  for i = 2, 8, 2 do
    coroutine.yield(i)
  end

  return 'who do we appreciate'
end, scheduler)

observable
  :map(function(value) return value .. '!' end)
  :subscribe(print)

repeat
  scheduler:update()
until scheduler:isEmpty()
