describe('startWith', function()
  it('produces errors emitted by the source', function()
    expect(Rx.Observable.throw():startWith(1).subscribe).to.fail()
  end)

  it('produces all specified elements in a single onNext before producing values normally', function()
    expect(Rx.Observable.fromRange(3, 4):startWith(1, 2)).to.produce({{1, 2}, {3}, {4}})
  end)
end)
