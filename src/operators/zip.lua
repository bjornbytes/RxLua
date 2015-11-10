local Observable = require 'observable'
local util = require 'util'

--- Returns an Observable that merges the values produced by the source Observables by grouping them
-- by their index.  The first onNext event contains the first value of all of the sources, the
-- second onNext event contains the second value of all of the sources, and so on.  onNext is called
-- a number of times equal to the number of values produced by the Observable that produces the
-- fewest number of values.
-- @arg {Observable...} sources - The Observables to zip.
-- @returns {Observable}
function Observable.zip(...)
  local sources = util.pack(...)
  local count = #sources

  return Observable.create(function(observer)
    local values = {}
    local active = {}
    for i = 1, count do
      values[i] = {n = 0}
      active[i] = true
    end

    local function onNext(i)
      return function(value)
        table.insert(values[i], value)
        values[i].n = values[i].n + 1

        local ready = true
        for i = 1, count do
          if values[i].n == 0 then
            ready = false
            break
          end
        end

        if ready then
          local payload = {}

          for i = 1, count do
            payload[i] = table.remove(values[i], 1)
            values[i].n = values[i].n - 1
          end

          observer:onNext(util.unpack(payload))
        end
      end
    end

    local function onError(message)
      return observer:onError(message)
    end

    local function onCompleted(i)
      return function()
        active[i] = nil
        if not next(active) or values[i].n == 0 then
          return observer:onCompleted()
        end
      end
    end

    for i = 1, count do
      sources[i]:subscribe(onNext(i), onError, onCompleted(i))
    end
  end)
end
