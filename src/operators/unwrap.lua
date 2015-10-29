local Observable = require 'observable'

--- Returns an Observable that takes any values produced by the original that consist of multiple
-- return values and produces each value individually.
-- @returns {Observable}
function Observable:unwrap()
  return Observable.create(function(observer)
    local function onNext(...)
      local values = {...}
      for i = 1, #values do
        observer:onNext(values[i])
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
