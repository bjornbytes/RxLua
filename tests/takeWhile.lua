describe('takeWhile', function()
  it('produces an error if its parent errors', function()
    local observable = Rx.Observable.of(''):map(function(x) return x() end)
    expect(observable.subscribe).to.fail()
    expect(observable:takeWhile(function() end).subscribe).to.fail()
  end)

  it('uses the identity function if no predicate is specified', function()
    local observable = Rx.Observable.fromTable({true, true, false}):takeWhile()
    expect(observable).to.produce(true, true)
  end)

  it('stops producing values once the predicate returns false', function()
    local function isEven(x) return x % 2 == 0 end
    local observable = Rx.Observable.fromTable({2, 3, 4}, ipairs):takeWhile(isEven)
    expect(observable).to.produce(2)
  end)

  it('produces no values if the predicate never returns true', function()
    local function isEven(x) return x % 2 == 0 end
    local observable = Rx.Observable.fromTable({1, 3, 5}):takeWhile(isEven)
    expect(observable).to.produce.nothing()
  end)

  it('calls onError if the predicate errors', function()
    local onError = spy()
    Rx.Observable.fromRange(3):takeWhile(error):subscribe(nil, onError, nil)
    expect(#onError).to.equal(1)
  end)
end)
