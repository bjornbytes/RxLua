describe('count', function()
  it('passes through errors', function()
    expect(Rx.Observable.throw():count()).to.produce.error()
  end)

  it('produces a single value representing the number of elements produced by the source', function()
    local observable = Rx.Observable.fromRange(5):count()
    expect(observable).to.produce(5)
  end)

  it('uses the predicate to filter for values if it is specified', function()
    local observable = Rx.Observable.fromRange(5):count(function(x) return x > 3 end)
    expect(observable).to.produce(2)
  end)

  it('calls onError if the predicate errors', function()
    expect(Rx.Observable.fromRange(3):count(error)).to.produce.error()
  end)
end)
