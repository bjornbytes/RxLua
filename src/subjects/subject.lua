local Observable = require 'observable'
local util = require 'util'

--- @class Subject
-- @description Subjects function both as an Observer and as an Observable. Subjects inherit all
-- Observable functions, including subscribe. Values can also be pushed to the Subject, which will
-- be broadcasted to any subscribed Observers.
local Subject = setmetatable({}, Observable)
Subject.__index = Subject
Subject.__tostring = util.constant('Subject')

--- Creates a new Subject.
-- @returns {Subject}
function Subject.create()
  local self = {
    observers = {},
    stopped = false
  }

  return setmetatable(self, Subject)
end

--- Creates a new Observer and attaches it to the Subject.
-- @arg {function|table} onNext|observer - A function called when the Subject produces a value or
--                                         an existing Observer to attach to the Subject.
-- @arg {function} onError - Called when the Subject terminates due to an error.
-- @arg {function} onComplete - Called when the Subject completes normally.
function Subject:subscribe(onNext, onError, onComplete)
  local observer

  if type(onNext) == 'table' then
    observer = onNext
  else
    observer = Observer.create(onNext, onError, onComplete)
  end

  table.insert(self.observers, observer)
end

--- Pushes zero or more values to the Subject. They will be broadcasted to all Observers.
-- @arg {*...} values
function Subject:onNext(...)
  if not self.stopped then
    for i = 1, #self.observers do
      self.observers[i]:onNext(...)
    end
  end
end

--- Signal to all Observers that an error has occurred.
-- @arg {string=} message - A string describing what went wrong.
function Subject:onError(message)
  if not self.stopped then
    for i = 1, #self.observers do
      self.observers[i]:onError(message)
    end

    self.stopped = true
  end
end

--- Signal to all Observers that the Subject will not produce any more values.
function Subject:onComplete()
  if not self.stopped then
    for i = 1, #self.observers do
      self.observers[i]:onComplete()
    end

    self.stopped = true
  end
end

Subject.__call = Subject.onNext

return Subject
