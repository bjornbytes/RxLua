local Observable = require 'observable'

--- Returns an Observable that restarts in the event of an error.
-- @arg {number=} count - The maximum number of times to retry.  If left unspecified, an infinite
--                        number of retries will be attempted.
-- @returns {Observable}
function Observable:retry(count)
  return Observable.create(function(observer)
    local subscription
    local retries = 0

    local function onNext(...)
      return observer:onNext(...)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    local function onError(message)
      if subscription then
        subscription:unsubscribe()
      end

      retries = retries + 1
      if count and retries > count then
        return observer:onError(message)
      end

      subscription = self:subscribe(onNext, onError, onCompleted)
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
