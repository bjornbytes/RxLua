local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that produces a single boolean value representing whether or not the
-- specified value was produced by the original.
-- @arg {*} value - The value to search for.  == is used for equality testing.
-- @returns {Observable}
function Observable:contains(value)
  return Observable.create(function(observer)
    local subscription

    local function onNext(...)
      local args = util.pack(...)

      if #args == 0 and value == nil then
        observer:onNext(true)
        if subscription then subscription:unsubscribe() end
        return observer:onCompleted()
      end

      for i = 1, #args do
        if args[i] == value then
          observer:onNext(true)
          if subscription then subscription:unsubscribe() end
          return observer:onCompleted()
        end
      end
    end

    local function onError(e)
      return observer:onError(e)
    end

    local function onCompleted()
      observer:onNext(false)
      return observer:onCompleted()
    end

    subscription = self:subscribe(onNext, onError, onCompleted)
    return subscription
  end)
end
