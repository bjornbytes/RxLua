local Rx = require 'rx'

-- Create an observable that produces a single value and print it.
Rx.Observable.fromValue(42):subscribe(print)
