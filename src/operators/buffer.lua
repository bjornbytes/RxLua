local Observable = require 'observable'
local util = require 'util'

--- Returns an Observable that buffers values from the original and produces them as multiple
-- values.
-- @arg {number} size - The size of the buffer.
function Observable:buffer(size)
  return Observable.create(function(observer)
    local buffer = {}

    local function emit()
      if #buffer > 0 then
        observer:onNext(util.unpack(buffer))
        buffer = {}
      end
    end

    local function onNext(...)
      local values = {...}
      for i = 1, #values do
        table.insert(buffer, values[i])
        if #buffer >= size then
          emit()
        end
      end
    end

    local function onError(message)
      emit()
      return observer:onError(message)
    end

    local function onCompleted()
      emit()
      return observer:onCompleted()
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
