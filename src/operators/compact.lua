local Observable = require 'observable'
local util = require 'util'

--- Returns a new Observable that produces the values of the first with falsy values removed.
-- @returns {Observable}
function Observable:compact()
  return self:filter(util.identity)
end
