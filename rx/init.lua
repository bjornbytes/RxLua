local path = (...):gsub('%.init+$', '')

local Rx = {}

Rx.Observable = require(path .. '.observable')
Rx.Observer = require(path .. '.observer')

return Rx
