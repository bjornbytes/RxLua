local Observable = require 'observable'
local util = require 'util'

--- Returns an Observable that produces a specified number of elements from the end of a source
-- Observable.
-- @arg {number} count - The number of elements to produce.
-- @returns {Observable}
function Observable:takeLast(count)
  return Observable.create(function(observer)
    local buffer = {}

    local function onNext(...)
      table.insert(buffer, util.pack(...))
      if #buffer > count then
        table.remove(buffer, 1)
      end
    end

    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted()
      for i = 1, #buffer do
        observer:onNext(util.unpack(buffer[i]))
      end
      return observer:onCompleted()
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
