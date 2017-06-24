describe('defaultIfEmpty', function()
  it('errors if the source errors', function()
    local _, onError = observableSpy(Rx.Observable.throw():defaultIfEmpty(1))
    expect(#onError).to.equal(1)
  end)

  it('produces the values from the source unchanged if at least one value is produced', function()
    expect(Rx.Observable.fromRange(3):defaultIfEmpty(7)).to.produce(1, 2, 3)
  end)

  it('produces the values specified if the source produces no values', function()
    expect(Rx.Observable.empty():defaultIfEmpty(7, 8)).to.produce({{7, 8}})
  end)

  it('does not freak out if no values are specified', function()
    expect(Rx.Observable.empty():defaultIfEmpty()).to.produce({{}})
  end)
end)
