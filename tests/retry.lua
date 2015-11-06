describe('retry', function()
  it('produces values normally if no errors occur', function()
    expect(Rx.Observable.fromRange(3):retry()).to.produce(1, 2, 3)
  end)

  local function createBadObservable(errorCount)
    local i = 0
    return Rx.Observable.create(function(observer)
      i = i + 1
      observer:onNext()
      if i <= errorCount then
        observer:onError('error')
      else
        observer:onCompleted()
      end
    end)
  end

  it('does not retry if the count is less than or equal to zero', function()
    local onNext, onError, onCompleted
    onNext, onError, onCompleted = observableSpy(createBadObservable(1):retry(0))
    expect(#onNext).to.equal(1)
    expect(#onError).to.equal(1)
    expect(#onCompleted).to.equal(0)

    onNext, onError, onCompleted = observableSpy(createBadObservable(1):retry(-1))
    expect(#onNext).to.equal(1)
    expect(#onError).to.equal(1)
    expect(#onCompleted).to.equal(0)
  end)

  it('completes successfully if the number of errors is less than or equal to the number of retries', function()
    local onNext, onError, onCompleted
    onNext, onError, onCompleted = observableSpy(createBadObservable(1):retry(1))
    expect(#onNext).to.equal(2)
    expect(#onError).to.equal(0)
    expect(#onCompleted).to.equal(1)

    onNext, onError, onCompleted = observableSpy(createBadObservable(1):retry(2))
    expect(#onNext).to.equal(2)
    expect(#onError).to.equal(0)
    expect(#onCompleted).to.equal(1)
  end)

  it('produces an error if the number of errors is greater than the number of retries', function()
    local onNext, onError, onCompleted = observableSpy(createBadObservable(3):retry(2))
    expect(#onNext).to.equal(3)
    expect(#onError).to.equal(1)
    expect(#onCompleted).to.equal(0)
  end)
end)
