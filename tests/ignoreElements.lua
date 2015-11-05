describe('ignoreErrors', function()
  it('passes through errors from the source', function()
    expect(Rx.Observable.throw():ignoreElements().subscribe).to.fail()
  end)

  it('does not produce any values produced by the source', function()
    expect(Rx.Observable.fromRange(3):ignoreElements()).to.produce.nothing()
  end)
end)
