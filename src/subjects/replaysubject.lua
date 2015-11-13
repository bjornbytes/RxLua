local Subject = require 'subjects/subject'
local Observer = require 'observer'
local util = require 'util'

--- @class ReplaySubject
-- @description A Subject that provides new Subscribers with some or all of the most recently
-- produced values upon subscription.
local ReplaySubject = setmetatable({}, Subject)
ReplaySubject.__index = ReplaySubject
ReplaySubject.__tostring = util.constant('ReplaySubject')

--- Creates a new ReplaySubject.
-- @arg {number=} bufferSize - The number of values to send to new subscribers. If nil, an infinite
--                             buffer is used (note that this could lead to memory issues).
-- @returns {ReplaySubject}
function ReplaySubject.create(n)
  local self = {
    observers = {},
    stopped = false,
    buffer = {},
    bufferSize = n
  }

  return setmetatable(self, ReplaySubject)
end

--- Creates a new Observer and attaches it to the ReplaySubject. Immediately broadcasts the most
-- contents of the buffer to the Observer.
-- @arg {function} onNext - Called when the ReplaySubject produces a value.
-- @arg {function} onError - Called when the ReplaySubject terminates due to an error.
-- @arg {function} onCompleted - Called when the ReplaySubject completes normally.
function ReplaySubject:subscribe(onNext, onError, onCompleted)
  local observer

  if util.isa(onNext, Observer) then
    observer = onNext
  else
    observer = Observer.create(onNext, onError, onCompleted)
  end

  local subscription = Subject.subscribe(self, observer)

  for i = 1, #self.buffer do
    observer:onNext(util.unpack(self.buffer[i]))
  end

  return subscription
end

--- Pushes zero or more values to the ReplaySubject. They will be broadcasted to all Observers.
-- @arg {*...} values
function ReplaySubject:onNext(...)
  table.insert(self.buffer, util.pack(...))
  if self.bufferSize and #self.buffer > self.bufferSize then
    table.remove(self.buffer, 1)
  end

  return Subject.onNext(self, ...)
end

ReplaySubject.__call = ReplaySubject.onNext

return ReplaySubject
