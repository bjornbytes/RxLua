describe('Observer', function()
  describe('create', function()
    it('returns an Observer', function()
      expect(Rx.Observer.create()).to.be.an(Rx.Observer)
    end)

    it('assigns onNext, onError, and onCompleted', function()
      local function onNext() end
      local function onError() end
      local function onCompleted() end

      local observer = Rx.Observer.create(onNext, onError, onCompleted)

      expect(observer._onNext).to.equal(onNext)
      expect(observer._onError).to.equal(onError)
      expect(observer._onCompleted).to.equal(onCompleted)
    end)

    it('initializes stopped to false', function()
      expect(Rx.Observer.create().stopped).to.equal(false)
    end)
  end)

  describe('onNext', function()
    it('calls _onNext', function()
      local observer = Rx.Observer.create()
      local function run() observer:onNext() end
      expect(#spy(observer, '_onNext', run)).to.equal(1)
    end)

    it('passes all arguments to _onNext', function()
      local observer = Rx.Observer.create()
      local function run() observer:onNext(1, '2', 3, nil, 5) end
      expect(spy(observer, '_onNext', run)).to.equal({{1, '2', 3, nil, 5}})
    end)

    it('does not call _onNext if stopped is true', function()
      local observer = Rx.Observer.create()
      observer.stopped = true
      local function run() observer:onNext() end
      expect(#spy(observer, '_onNext', run)).to.equal(0)
    end)
  end)

  describe('onError', function()
    it('calls _onError with the first argument it was passed', function()
      local observer = Rx.Observer.create(_, function() end, _)
      local function run() observer:onError('sheeit', 1) end
      expect(spy(observer, '_onError', run)).to.equal({{'sheeit'}})
    end)

    it('sets stopped to true', function()
      local observer = Rx.Observer.create(_, function() end, _)
      observer:onError()
      expect(observer.stopped).to.equal(true)
    end)

    it('does not call _onError if stopped is already true', function()
      local observer = Rx.Observer.create(_, function() end, _)
      observer.stopped = true
      local function run() observer:onError() end
      expect(#spy(observer, '_onError', run)).to.equal(0)
    end)

    it('causes an error by default', function()
      local observer = Rx.Observer.create()
      expect(observer.onError).to.fail()
    end)
  end)

  describe('onCompleted', function()
    it('calls _onCompleted with no arguments', function()
      local observer = Rx.Observer.create()
      local function run() observer:onCompleted(1, 2, 3) end
      expect(spy(observer, '_onCompleted', run)).to.equal({{}})
    end)

    it('sets stopped to true', function()
      local observer = Rx.Observer.create()
      observer:onCompleted()
      expect(observer.stopped).to.equal(true)
    end)

    it('does not call _onCompleted if stopped is already true', function()
      local observer = Rx.Observer.create()
      observer.stopped = true
      local function run() observer:onCompleted() end
      expect(#spy(observer, '_onCompleted', run)).to.equal(0)
    end)
  end)
end)
