local Observable = require 'observable'

--- Returns a new Observable that skips over values produced by the original until the specified
-- Observable produces a value.
-- @arg {Observable} other - The Observable that triggers the production of values.
-- @returns {Observable}
function Observable:skipUntil(other)
  return Observable.create(function(observer)
    local triggered = false
    local function trigger()
      triggered = true
    end

    other:subscribe(trigger, trigger, trigger)

    local function onNext(...)
      if triggered then
        observer:onNext(...)
      end
    end

    local function onError()
      if triggered then
        observer:onError()
      end
    end

    local function onCompleted()
      if triggered then
        observer:onCompleted()
      end
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
