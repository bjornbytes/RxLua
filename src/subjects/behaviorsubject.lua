local Subject = require 'subjects/subject'
local util = require 'util'

--- @class BehaviorSubject
-- @description A Subject that tracks its current value. Provides an accessor to retrieve the most
-- recent pushed value, and all subscribers immediately receive the latest value.
local BehaviorSubject = setmetatable({}, Subject)
BehaviorSubject.__index = BehaviorSubject
BehaviorSubject.__tostring = util.constant('BehaviorSubject')

--- Creates a new BehaviorSubject.
-- @arg {*...} value - The initial values.
-- @returns {Subject}
function BehaviorSubject.create(...)
  local self = {
    observers = {},
    stopped = false
  }

  if select('#', ...) > 0 then
    self.value = util.pack(...)
  end

  return setmetatable(self, BehaviorSubject)
end

--- Creates a new Observer and attaches it to the Subject. Immediately broadcasts the most recent
-- value to the Observer.
-- @arg {function} onNext - Called when the Subject produces a value.
-- @arg {function} onError - Called when the Subject terminates due to an error.
-- @arg {function} onComplete - Called when the Subject completes normally.
function BehaviorSubject:subscribe(onNext, onError, onComplete)
  local observer = Observer.create(onNext, onError, onComplete)
  Subject.subscribe(self, observer)
  if self.value then
    observer:onNext(unpack(self.value))
  end
end

--- Pushes zero or more values to the BehaviorSubject. They will be broadcasted to all Observers.
-- @arg {*...} values
function BehaviorSubject:onNext(...)
  self.value = util.pack(...)
  return Subject.onNext(self, ...)
end

--- Returns the last value emitted by the Subject, or the initial value passed to the constructor
-- if nothing has been emitted yet.
-- @returns {*...}
function BehaviorSubject:getValue()
  return self.value and util.unpack(self.value)
end

return BehaviorSubject
