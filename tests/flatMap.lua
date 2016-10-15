describe('flatMap', function()
  it('produces an error if its parent errors', function()
    local observable = Rx.Observable.of(''):flatMap(function(x) return x() end)
    expect(observable.subscribe).to.fail()
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
end)
