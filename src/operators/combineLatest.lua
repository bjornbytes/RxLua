local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that runs a combinator function on the most recent values from a set
-- of Observables whenever any of them produce a new value. The results of the combinator function
-- are produced by the new Observable.
-- @arg {Observable...} observables - One or more Observables to combine.
-- @arg {function} combinator - A function that combines the latest result from each Observable and
--                              returns a single value.
-- @returns {Observable}
function Observable:combineLatest(...)
  local sources = {...}
  local combinator = table.remove(sources)
  if type(combinator) ~= 'function' then
    table.insert(sources, combinator)
    combinator = function(...) return ... end
  end
  table.insert(sources, 1, self)

  return Observable.create(function(observer)
    local latest = {}
    local pending = {util.unpack(sources)}
    local completed = {}

    local function onNext(i)
      return function(value)
        latest[i] = value
        pending[i] = nil

        if not next(pending) then
          util.tryWithObserver(observer, function()
            observer:onNext(combinator(util.unpack(latest)))
          end)
        end
      end
    end

    local function onError(e)
      return observer:onError(e)
    end

    local function onCompleted(i)
      return function()
        table.insert(completed, i)

        if #completed == #sources then
          observer:onCompleted()
        end
      end
    end

    for i = 1, #sources do
      sources[i]:subscribe(onNext(i), onError, onCompleted(i))
    end
  end)
end
