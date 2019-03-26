describe('skipWhile', function()
  it('produces an error if its parent errors', function()
    local observable = Rx.Observable.of(''):map(function(x) return x() end)
    expect(observable).to.produce.error()
    expect(observable:skipWhile(function() end)).to.produce.error()
  end)

  it('uses the identity function if no predicate is specified', function()
    local observable = Rx.Observable.fromTable({true, true, false}):skipWhile()
    expect(observable).to.produce(false)
  end)

  it('produces values once the predicate returns false', function()
    local function isEven(x) return x % 2 == 0 end
    local observable = Rx.Observable.fromTable({2, 3, 4}, ipairs):skipWhile(isEven)
    expect(observable).to.produce(3, 4)
  end)

  it('produces no values if the predicate never returns false', function()
    local function isEven(x) return x % 2 == 0 end
    local observable = Rx.Observable.fromTable({2, 4, 6}):skipWhile(isEven)
    expect(observable).to.produce.nothing()
  end)

  it('calls onError if the predicate errors', function()
    expect(Rx.Observable.fromRange(3):skipWhile(error)).to.produce.error()
  end)
end)
