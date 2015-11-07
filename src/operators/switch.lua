local Observable = require 'observable'

--- Given an Observable that produces Observables, returns an Observable that produces the values
-- produced by the most recently produced Observable.
-- @returns {Observable}
function Observable:switch()
  return Observable.create(function(observer)
    local subscription

    local function onNext(...)
      return observer:onNext(...)
    end

    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    local function switch(source)
      if subscription then
        subscription:unsubscribe()
      end

      subscription = source:subscribe(onNext, onError, nil)
    end

    return self:subscribe(switch, onError, onCompleted)
  end)
end
