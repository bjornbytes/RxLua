local Rx = require 'rx'

local first = Rx.Observable.fromRange(3)
local second = Rx.Observable.fromRange(4, 6)
local third = Rx.Observable.fromRange(7, 11, 2)

first:concat(second, third):dump('concat')

print('Equivalent to:')

Rx.Observable.concat(first, second, third):dump('concat')
