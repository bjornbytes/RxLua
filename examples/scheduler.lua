local Rx = require 'rx'
local timerResolution = .25
local function log(message)
  print('[' .. string.format('%.2f', Rx.scheduler.currentTime) .. '] ' .. message)
end

-- Demonstrate Rx.Scheduler.Cooperative by running some simultaneous cooperative threads.
Rx.scheduler:schedule(function()
  log('this is like a setTimeout')
end, 2)

Rx.scheduler:schedule(function()
  local i = 1
  while true do
    log('this prints i twice per second: ' .. i)
    i = i + 1
    coroutine.yield(.5)
  end
end)

Rx.scheduler:schedule(function()
  for i = 1, 3 do
    log('this will print for 3 updates after 1 second')
    coroutine.yield()
  end
end, 1)

-- Simulate 3 virtual seconds.
repeat
  Rx.scheduler:update(timerResolution)
until Rx.scheduler.currentTime >= 3
