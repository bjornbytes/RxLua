local Observable = require 'observable'

--- Returns an Observable that produces the nth element produced by the source Observable.
-- @arg {number} index - The index of the item, with an index of 1 representing the first.
-- @returns {Observable}
function Observable:elementAt(index)
  return Observable.create(function(observer)
    local subscription
    local i = 1

    local function onNext(...)
      if i == index then
        observer:onNext(...)
        observer:onCompleted()
        if subscription then
          subscription:unsubscribe()
        end
      else
        i = i + 1
      end
    end

    local function onError(e)
      return observer:onError(e)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    subscription = self:subscribe(onNext, onError, onCompleted)
    return subscription
  end)
end
