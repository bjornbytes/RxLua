local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that produces its most recent value every time the specified observable
-- produces a value.
-- @arg {Observable} sampler - The Observable that is used to sample values from this Observable.
-- @returns {Observable}
function Observable:sample(sampler)
  if not sampler then error('Expected an Observable') end

  return Observable.create(function(observer)
    local latest = {}

    local function setLatest(...)
      latest = util.pack(...)
    end

    local function onNext()
      return observer:onNext(util.unpack(latest))
    end

    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    local sourceSubscription = self:subscribe(setLatest, onError)
    local sampleSubscription = sampler:subscribe(onNext, onError, onCompleted)

    return Subscription.create(function()
      if sourceSubscription then sourceSubscription:unsubscribe() end
      if sampleSubscription then sampleSubscription:unsubscribe() end
    end)
  end)
end
