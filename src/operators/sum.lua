local Observable = require 'observable'

--- Returns an Observable that produces a single value representing the sum of the values produced
-- by the original.
-- @returns {Observable}
function Observable:sum()
  return self:reduce(function(x, y) return x + y end, 0)
end
