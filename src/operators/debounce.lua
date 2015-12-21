local Observable = require 'observable'
local Subscription = require 'subscription'
local util = require 'util'

function Observable:debounce(time, scheduler)
  time = time or 0

  return Observable.create(function(observer)
    local function wrap(key)
      local debounced
      return function(...)
        local value = util.pack(...)

        if debounced then
          debounced:unsubscribe()
        end

        local values = util.pack(...)

        debounced = scheduler:schedule(function()
          return observer[key](observer, util.unpack(values))
        end, time)
      end
    end

    local subscription = self:subscribe(wrap('onNext'), wrap('onError'), wrap('onCompleted'))

    return Subscription.create(function()

    end)
  end)
end
