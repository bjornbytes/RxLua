local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that subscribes to the Observables produced by the original and
-- produces their values.
-- @returns {Observable}
function Observable:flatten()
  return Observable.create(function(observer)
    local function onError(message)
      return observer:onError(message)
    end

    local function onNext(observable)
      local function innerOnNext(...)
        observer:onNext(...)
      end

      observable:subscribe(innerOnNext, onError, util.noop)
    end

    local function onCompleted()
      return observer:onCompleted()
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end
