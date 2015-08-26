local Rx = require 'rx'

local subject = Rx.Subject.create()

subject:subscribe(function(x)
  print('observer a ' .. x)
end)

subject:subscribe(function(x)
  print('observer b ' .. x)
end)

subject:onNext(1)
subject(2)
subject:onNext(3)
