describe('skipLast', function()
  it('produces an error if its parent errors', function()
    expect(Rx.Observable.throw():skipLast(1).subscribe).to.fail()
  end)

  it('fails if the count is not specified', function()
    expect(Rx.Observable.fromRange(3):skipLast().subscribe).to.fail()
  end)

  it('skips the specified number of values from the end of the source Observable', function()
    expect(Rx.Observable.fromRange(5):skipLast(2)).to.produce(1, 2, 3)
  end)

  it('produces all elements produced by the source if the count is less than or equal to zero', function()
    expect(Rx.Observable.fromRange(3):skipLast(-1)).to.produce(1, 2, 3)
  end)
end)
