describe('Observer', function()
  describe('.create', function()
    it('returns an Observer', function()
      expect(Rx.Observer.create()).to.be.an(Rx.Observer)
    end)

    it('assigns onNext, onError, and onComplete', function()
      local function onNext() end
      local function onError() end
      local function onComplete() end

      local observer = Rx.Observer.create(onNext, onError, onComplete)

      expect(observer._onNext).to.equal(onNext)
      expect(observer._onError).to.equal(onError)
      expect(observer._onComplete).to.equal(onComplete)
    end)

    it('initializes stopped to false', function()
      expect(Rx.Observer.create().stopped).to.equal(false)
    end)
  end)

  describe('.onNext', function()
    it('calls _onNext', function()
      local observer = Rx.Observer.create()
      local function run() observer:onNext() end
      local calls = spy(observer, '_onNext', run)
      expect(#calls).to.equal(1)
    end)

    it('passes all arguments to _onNext', function()
      local observer = Rx.Observer.create()
      local function run() observer:onNext(1, '2', 3, nil, 5) end
      local calls = spy(observer, '_onNext', run)
      expect(calls).to.equal({{1, '2', 3, nil, 5}})
    end)

    it('does not call _onNext if onComplete has been called', function()
      local observer = Rx.Observer.create()
      local function run()
        observer:onComplete()
        observer:onNext()
      end
      expect(#spy(observer, '_onNext', run)).to.equal(0)
    end)

    it('does not call _onNext if onError has been called', function()
      local observer = Rx.Observer.create(_, function() end, _)
      local function run()
        observer:onError()
        observer:onNext()
      end
      expect(#spy(observer, '_onNext', run)).to.equal(0)
    end)
  end)
end)
