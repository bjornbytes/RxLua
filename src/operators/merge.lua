local Observable = require 'observable'

--- Returns a new Observable that produces the values produced by all the specified Observables in
-- the order they are produced.
-- @arg {Observable...} sources - One or more Observables to merge.
-- @returns {Observable}
function Observable:merge(...)
  local sources = {...}
  table.insert(sources, 1, self)

  return Observable.create(function(observer)
    local function onNext(...)
      return observer:onNext(...)
    end

    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted(i)
      return function()
        sources[i] = nil

        if not next(sources) then
          observer:onCompleted()
        end
      end
    end

    for i = 1, #sources do
      sources[i]:subscribe(onNext, onError, onCompleted(i))
    end
  end)
end
