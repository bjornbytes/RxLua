local Rx = require 'rx'
local scheduler = Rx.CooperativeScheduler.create()
local timerResolution = .25
local function log(message)
  print('[' .. string.format('%.2f', scheduler.currentTime) .. '] ' .. message)
end

-- Demonstrate Rx.Scheduler.Cooperative by running some simultaneous cooperative threads.
scheduler:schedule(function()
  log('this is like a setTimeout')
end, 2)

scheduler:schedule(function()
  local i = 1
  while true do
    log('this prints i twice per second: ' .. i)
    i = i + 1
    coroutine.yield(.5)
  end
end)

scheduler:schedule(function()
  for i = 1, 3 do
    log('this will print for 3 updates after 1 second')
    coroutine.yield()
  end
end, 1)

-- Simulate 3 virtual seconds.
repeat
  scheduler:update(timerResolution)
until scheduler.currentTime >= 3
