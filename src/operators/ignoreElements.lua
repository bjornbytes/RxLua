local Observable = require 'observable'

--- Returns an Observable that terminates when the source terminates but does not produce any
-- elements.
-- @returns {Observable}
function Observable:ignoreElements()
  return Observable.create(function(observer)
    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    return self:subscribe(nil, onError, onCompleted)
  end)
end
