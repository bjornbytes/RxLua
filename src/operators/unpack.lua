local Observable = require 'observable'
local util = require 'util'

--- Returns an Observable that unpacks the tables produced by the original.
-- @returns {Observable}
function Observable:unpack()
  return self:map(util.unpack)
end
