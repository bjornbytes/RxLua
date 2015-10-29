local Observable = require 'observable'

--- Returns a new Observable that produces the maximum value produced by the original.
-- @returns {Observable}
function Observable:max()
  return self:reduce(math.max)
end
