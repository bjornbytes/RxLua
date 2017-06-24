describe('filter', function()
  it('uses the identity function as the predicate if none is specified', function()
    local observable = Rx.Observable.fromTable({false, true}):filter()
    expect(observable).to.produce(true)
  end)

  it('passes all arguments to the predicate', function()
    local predicate = spy()
    Rx.Observable.fromTable({{1, 2}, {3, 4, 5}}, ipairs):unpack():filter(predicate):subscribe()
    expect(predicate).to.equal({{1, 2}, {3, 4, 5}})
  end)

  it('does not produce elements that the predicate returns false for', function()
    local predicate = function(x) return x % 2 == 0 end
    local observable = Rx.Observable.fromRange(1, 5):filter(predicate)
    expect(observable).to.produce(2, 4)
  end)

  it('errors when its parent errors', function()
    local _, onError = observableSpy(Rx.Observable.throw():filter())
    expect(#onError).to.equal(1)
  end)

  it('calls onError if the predicate errors', function()
    local onError = spy()
    Rx.Observable.of(5):filter(error):subscribe(nil, onError, nil)
    expect(#onError).to.equal(1)
  end)
end)
