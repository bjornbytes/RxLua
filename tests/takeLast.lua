describe('takeLast', function()
  it('produces an error if its parent errors', function()
    expect(Rx.Observable.throw():takeLast(1).subscribe).to.fail()
  end)

  it('produces an error if the count is not specified', function()
    expect(Rx.Observable.fromRange(3):takeLast().subscribe).to.fail()
  end)

  it('produces nothing if the count is zero', function()
    local observable = Rx.Observable.fromRange(3):takeLast(0)
    expect(observable).to.produce.nothing()
  end)

  it('produces all values if the count is greater than the number of elements produced', function()
    local observable = Rx.Observable.fromRange(3):takeLast(10)
    expect(observable).to.produce(1, 2, 3)
  end)

  it('produces no elements if the count is less than or equal to zero', function()
    expect(Rx.Observable.fromRange(3):takeLast(0)).to.produce.nothing()
    expect(Rx.Observable.fromRange(3):takeLast(-1)).to.produce.nothing()
  end)

  it('produces no elements if the source Observable produces no elements', function()
    expect(Rx.Observable.empty():takeLast(1)).to.produce.nothing()
  end)
end)
