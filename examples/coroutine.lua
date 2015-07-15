local Rx = require 'rx'

-- Observable created from a coroutine that produces two values.
local cr = coroutine.create(function()
  coroutine.yield('hello')
  return 'world'
end)

Rx.Observable.fromCoroutine(cr):dump('coroutine')
