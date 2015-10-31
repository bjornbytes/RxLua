describe('sum', function()
  it('passes through errors from the source', function()
    expect(Rx.Observable.throw():sum().subscribe).to.fail()
  end)

  it('produces the sum of the numeric values from the source', function()
    expect(Rx.Observable.fromRange(3):sum()).to.produce(6)
  end)
end)
