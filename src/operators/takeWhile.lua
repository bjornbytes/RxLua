local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that produces elements until the predicate returns falsy.
-- @arg {function} predicate - The predicate used to continue production of values.
-- @returns {Observable}
function Observable:takeWhile(predicate)
  predicate = predicate or util.identity

  return Observable.create(function(observer)
    local taking = true

    local function onNext(...)
      if taking then
        util.tryWithObserver(observer, function(...)
          taking = predicate(...)
        end, ...)

        if taking then
          return observer:onNext(...)
        else
          return observer:onCompleted()
        end
      end
    end

    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
