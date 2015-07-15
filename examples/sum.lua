local Rx = require 'rx'

-- Uses the 'sum' combinator to sum all values produced by the observable and
-- dumps the resulting output.
local sumObservable = Rx.Observable.create(function(observer)
  observer:onNext(1)
  observer:onNext(2)
  observer:onNext(3)
  observer:onNext(4)
  observer:onCompleted()
end)

sumObservable:sum():dump('sum')
