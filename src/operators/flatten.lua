local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that subscribes to the Observables produced by the original and
-- produces their values.
-- @returns {Observable}
function Observable:flatten()
  return Observable.create(function(observer)
    local subscriptions = {}

    local function onError(message)
      return observer:onError(message)
    end

    local function onNext(observable)
      local function innerOnNext(...)
        observer:onNext(...)
      end

      local subscription = observable:subscribe(innerOnNext, onError, util.noop)
      subscriptions[#subscriptions + 1] = subscription
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    subscriptions[#subscriptions + 1] = self:subscribe(onNext, onError, onCompleted)
    return Subscription.create(function ()
      for i = 1, #subscriptions do
        subscriptions[i]:unsubscribe()
      end
    end)
  end)
end
