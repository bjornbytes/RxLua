local rx = require 'rx'

local timerResolution = .25
local function log(message)
  print('[' .. string.format('%.2f', rx.scheduler.currentTime) .. '] ' .. message)
end

rx.scheduler:schedule(function()
  log('this is like a setTimeout')
end, 2)

rx.scheduler:schedule(function()
  local i = 1
  while true do
    log('this prints i twice per second: ' .. i)
    i = i + 1
    coroutine.yield(.5)
  end
end)

rx.scheduler:schedule(function()
  for i = 1, 3 do
    log('this will print for 3 updates after 1 second')
    coroutine.yield()
  end
end, 1)

repeat
  rx.scheduler:update(timerResolution)
  os.execute('sleep ' .. timerResolution)
until rx.scheduler.currentTime >= 3
