local Observable = require 'observable'
local Observer = require 'observer'
local Subscription = require 'subscription'
local util = require 'util'

--- @class AsyncSubject
-- @description AsyncSubjects are subjects that produce either no values or a single value.  If
-- multiple values are produced via onNext, only the last one is used.  If onError is called, then
-- no value is produced and onError is called on any subscribed Observers.  If an Observer
-- subscribes and the AsyncSubject has already terminated, the Observer will immediately receive the
-- value or the error.
local AsyncSubject = setmetatable({}, Observable)
AsyncSubject.__index = AsyncSubject
AsyncSubject.__tostring = util.constant('AsyncSubject')

--- Creates a new AsyncSubject.
-- @returns {AsyncSubject}
function AsyncSubject.create()
  local self = {
    observers = {},
    stopped = false,
    value = nil,
    errorMessage = nil
  }

  return setmetatable(self, AsyncSubject)
end

--- Creates a new Observer and attaches it to the AsyncSubject.
-- @arg {function|table} onNext|observer - A function called when the AsyncSubject produces a value
--                                         or an existing Observer to attach to the AsyncSubject.
-- @arg {function} onError - Called when the AsyncSubject terminates due to an error.
-- @arg {function} onCompleted - Called when the AsyncSubject completes normally.
function AsyncSubject:subscribe(onNext, onError, onCompleted)
  local observer

  if util.isa(onNext, Observer) then
    observer = onNext
  else
    observer = Observer.create(onNext, onError, onCompleted)
  end

  if self.value then
    observer:onNext(util.unpack(self.value))
    observer:onCompleted()
    return
  elseif self.errorMessage then
    observer:onError(self.errorMessage)
    return
  end

  table.insert(self.observers, observer)

  return Subscription.create(function()
    for i = 1, #self.observers do
      if self.observers[i] == observer then
        table.remove(self.observers, i)
        return
      end
    end
  end)
end

--- Pushes zero or more values to the AsyncSubject.
-- @arg {*...} values
function AsyncSubject:onNext(...)
  if not self.stopped then
    self.value = util.pack(...)
  end
end

--- Signal to all Observers that an error has occurred.
-- @arg {string=} message - A string describing what went wrong.
function AsyncSubject:onError(message)
  if not self.stopped then
    self.errorMessage = message

    for i = 1, #self.observers do
      self.observers[i]:onError(self.errorMessage)
    end

    self.stopped = true
  end
end

--- Signal to all Observers that the AsyncSubject will not produce any more values.
function AsyncSubject:onCompleted()
  if not self.stopped then
    for i = 1, #self.observers do
      if self.value then
        self.observers[i]:onNext(util.unpack(self.value))
      end

      self.observers[i]:onCompleted()
    end

    self.stopped = true
  end
end

AsyncSubject.__call = AsyncSubject.onNext

return AsyncSubject
