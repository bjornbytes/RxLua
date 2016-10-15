local Rx = require 'rx'

-- Create an observable that produces a single value and print it.
Rx.Observable.of(42):subscribe(print)
