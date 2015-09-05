describe('find', function()
  it('produces an error if its parent errors', function()
    local observable = Rx.Observable.fromValue(''):map(function(x) return x() end)
    expect(observable.subscribe).to.fail()
    expect(observable:find().subscribe).to.fail()
  end)

  it('uses the identity function as a predicate if none is specified', function()
    local observable = Rx.Observable.fromTable({false, false, true, true, false}):find()
    expect(observable).to.produce(true)
  end)

  it('passes all arguments to the predicate', function()
    local predicate = spy()

    local observable = Rx.Observable.create(function(observer)
      observer:onNext(1, 2, 3)
      observer:onNext(4, 5, 6)
      observer:onComplete()
    end)

    observable:find(predicate):subscribe()

    expect(predicate).to.equal({{1, 2, 3}, {4, 5, 6}})
  end)

  it('produces the first element for which the predicate returns true and completes', function()
    local observable = Rx.Observable.fromRange(5):find(function(x) return x > 3 end)
    expect(observable).to.produce(4)
  end)

  it('completes after its parent completes if no value satisfied the predicate', function()
    local observable = Rx.Observable.fromRange(5):find(function() return false end)
    expect(observable).to.produce({})
  end)
end)
