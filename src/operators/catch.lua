local Observable = require 'observable'
local util = require 'util'

--- Returns an Observable that intercepts any errors from the previous and replace them with values
-- produced by a new Observable.
-- @arg {function|Observable} handler - An Observable or a function that returns an Observable to
--                                       replace the source Observable in the event of an error.
-- @returns {Observable}
function Observable:catch(handler)
  handler = handler and (type(handler) == 'function' and handler or util.constant(handler))

  return Observable.create(function(observer)
    local subscription

    local function onNext(...)
      return observer:onNext(...)
    end

    local function onError(e)
      if not handler then
        return observer:onCompleted()
      end

      local continue = handler(e)
      if continue then
        if subscription then subscription:unsubscribe() end
        continue:subscribe(observer)
      else
        observer:onError(e)
      end
    end

    local function onCompleted()
      observer:onCompleted()
    end

    subscription = self:subscribe(onNext, onError, onCompleted)
    return subscription
  end)
end
