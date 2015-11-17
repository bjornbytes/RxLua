local Observable = require 'observable'
local util = require 'util'

--- Returns an Observable that produces a single value representing the number of values produced
-- by the source value that satisfy an optional predicate.
-- @arg {function=} predicate - The predicate used to match values.
function Observable:count(predicate)
  predicate = predicate or util.constant(true)

  return Observable.create(function(observer)
    local count = 0

    local function onNext(...)
      util.tryWithObserver(observer, function(...)
        if predicate(...) then
          count = count + 1
        end
      end, ...)
    end

    local function onError(e)
      return observer:onError(e)
    end

    local function onCompleted()
      observer:onNext(count)
      observer:onCompleted()
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
