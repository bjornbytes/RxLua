local Rx = require 'rx'

-- Observable created from a coroutine.
local cheer = coroutine.create(function()
  for i = 2, 8, 2 do
    coroutine.yield(i)
  end

  return 'who do we appreciate'
end)

Rx.Observable.fromCoroutine(cheer):dump('cheer')

repeat
  Rx.scheduler:update()
until Rx.scheduler:isEmpty()
