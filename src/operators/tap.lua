local Observable = require 'observable'
local util = require 'util'

--- Runs a function each time this Observable has activity. Similar to subscribe but does not
-- create a subscription.
-- @arg {function=} onNext - Run when the Observable produces values.
-- @arg {function=} onError - Run when the Observable encounters a problem.
-- @arg {function=} onCompleted - Run when the Observable completes.
-- @returns {Observable}
function Observable:tap(_onNext, _onError, _onCompleted)
  _onNext = _onNext or util.noop
  _onError = _onError or util.noop
  _onCompleted = _onCompleted or util.noop

  return Observable.create(function(observer)
    local function onNext(...)
      _onNext(...)
      return observer:onNext(...)
    end

    local function onError(message)
      _onError(message)
      return observer:onError(message)
    end

    local function onCompleted()
      _onCompleted()
      return observer:onCompleted()
    end

    return self:subscribe(onNext, onError, onCompleted)
  end)
end

