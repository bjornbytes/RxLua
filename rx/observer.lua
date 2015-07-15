local Observer = {}
Observer.__index = Observer

local function noop() end
local function defaultError(e) error(e) end

function Observer.create(onNext, onError, onCompleted)
  local self = {
    _onNext = onNext or noop,
    _onError = onError or defaultError,
    _onCompleted = onCompleted or noop,
    stopped = false
  }

  return setmetatable(self, Observer)
end

function Observer:onNext(value)
  if not self.stopped then
    self._onNext(value)
  end
end

function Observer:onError(e)
  if not self.stopped then
    self.stopped = true
    self._onError(e)
  end
end

function Observer:onCompleted()
  if not self.stopped then
    self.stopped = true
    self._onCompleted()
  end
end

return Observer
