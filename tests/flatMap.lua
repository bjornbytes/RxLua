describe('flatMap', function()
  it('produces an error if its parent errors', function()
    local observable = Rx.Observable.of(''):flatMap(function(x) return x() end)
    expect(observable).to.produce.error()
  end)

  it('uses the identity function as the callback if none is specified', function()
    local observable = Rx.Observable.fromTable{
      Rx.Observable.fromRange(3),
      Rx.Observable.fromRange(5)
    }:flatMap()
    expect(observable).to.produce(1, 2, 3, 1, 2, 3, 4, 5)
  end)

  it('produces all values produced by the observables produced by its parent', function()
    local observable = Rx.Observable.fromRange(3):flatMap(function(i)
      return Rx.Observable.fromRange(i, 3)
    end)

    expect(observable).to.produce(1, 2, 3, 2, 3, 3)
  end)

  it('completes after all observables produced by its parent', function()
    s = Rx.CooperativeScheduler.create()
    local observable = Rx.Observable.fromRange(3):flatMap(function(i)
      return Rx.Observable.fromRange(i, 3):delay(i, s)
    end)

    local onNext, onError, onCompleted, order = observableSpy(observable)
    repeat s:update(1)
    until s:isEmpty()
    expect(#onNext).to.equal(6)
    expect(#onCompleted).to.equal(1)
  end)
end)
