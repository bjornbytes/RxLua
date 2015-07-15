local path = (...):gsub('%.[^%.]+$', '')
local Observer = require(path .. '.observer')

local Observable = {}
Observable.__index = Observable

function Observable.create(subscribe)
  local self = {
    _subscribe = subscribe
  }

  return setmetatable(self, Observable)
end

function Observable.fromValue(value)
  return Observable.create(function(observer)
    observer:onNext(value)
    observer:onCompleted()
  end)
end

function Observable.fromCoroutine(cr)
  return Observable.create(function(observer)
    while true do
      local success, value = coroutine.resume(cr)
      observer:onNext(value)
      if coroutine.status(cr) == 'dead' then break end
    end

    observer:onCompleted()
  end)
end

function Observable:subscribe(onNext, onError, onComplete)
  return self._subscribe(Observer.create(onNext, onError, onComplete))
end

function Observable:dump(name)
  name = name or ''

  local onNext = function(x) print(name .. ' onNext: ' .. x) end
  local onError = function(e) error(name .. ' onError: ' .. e) end
  local onCompleted = function() print(name .. ' onCompleted') end

  return self:subscribe(onNext, onError, onCompleted)
end

-- Combinators

function Observable:first()
  return Observable.create(function(observer)
    return self:subscribe(function(x)
      observer:onNext(x)
      observer:onCompleted()
    end,
    function(e)
      observer:onError(e)
    end,
    function()
      observer:onCompleted()
    end)
  end)
end

function Observable:last()
  return Observable.create(function(observer)
    local value
    return self:subscribe(function(x)
      value = x
    end,
    function(e)
      observer:onError(e)
    end,
    function()
      observer:onNext(value)
      observer:onCompleted()
    end)
  end)
end

function Observable:map(fn)
  fn = fn or function(x) return x end
  return Observable.create(function(observer)
    return self:subscribe(function(x)
      observer:onNext(fn(x))
    end,
    function(e)
      observer:onError(e)
    end,
    function()
      observer:onCompleted()
    end)
  end)
end

function Observable:reduce(accumulator, seed)
  return Observable.create(function(observer)
    local currentValue = nil or seed
    return self:subscribe(function(x)
      currentValue = accumulator(currentValue, x)
    end,
    function(e)
      observer:onError(e)
    end,
    function()
      observer:onNext(currentValue)
      observer:onCompleted()
    end)
  end)
end

function Observable:sum()
  return self:reduce(function(x, y) return x + y end, 0)
end

function Observable:combineLatest(...)
  local values = {}
  local done = {}
  local targets = {...}
  local fn = table.remove(targets)
  table.insert(targets, 1, self)

  return Observable.create(function(observer)
    local function handleNext(k, v)
      values[k] = v
      local full = true
      for i = 1, #targets do
        if not values[i] then full = false break end
      end

      if full then
        observer:onNext(fn(unpack(values)))
      end
    end

    local function handleCompleted(k)
      done[k] = true
      local stop = true
      for i = 1, #targets do
        if not done[i] then stop = false break end
      end

      if stop then
        observer:onCompleted()
      end
    end

    for i = 1, #targets do
      targets[i]:subscribe(function(x)
        values[i] = x
        handleNext(i, x)
      end,
      function(e)
        observer:onError(e)
      end,
      function()
        handleCompleted(i)
      end)
    end
  end)
end

return Observable
