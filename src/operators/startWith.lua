local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that produces the specified values followed by all elements produced by
-- the source Observable.
-- @arg {*...} values - The values to produce before the Observable begins producing values
--                      normally.
-- @returns {Observable}
function Observable:startWith(...)
  local values = util.pack(...)
  return Observable.create(function(observer)
    observer:onNext(util.unpack(values))
    return self:subscribe(observer)
  end)
end
