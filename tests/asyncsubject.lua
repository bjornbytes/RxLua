describe('AsyncSubject', function()
  describe('create', function()
    it('returns an AsyncSubject', function()
      expect(Rx.AsyncSubject.create()).to.be.an(Rx.AsyncSubject)
    end)

    it('does not fail if passed arguments', function()
      expect(Rx.AsyncSubject.create(1, 2, 3)).to.be.an(Rx.AsyncSubject)
    end)
  end)

  describe('subscribe', function()
    describe('if the AsyncSubject has already completed', function()
      it('calls onNext if the AsyncSubject has a value and calls onCompleted', function()
        local subject = Rx.AsyncSubject.create()
        subject:onNext(5)
        subject:onCompleted()

        local onNext, onError, onCompleted = spy(), spy(), spy()
        subject:subscribe(onNext, onError, onCompleted)

        expect(onNext).to.equal({{5}})
        expect(#onError).to.equal(0)
        expect(#onCompleted).to.equal(1)
      end)

      it('calls onError on the Observer if the AsyncSubject has an error', function()
        local subject = Rx.AsyncSubject.create()
        subject:onError('ohno')

        local onNext, onError, onCompleted = spy(), spy(), spy()
        subject:subscribe(onNext, onError, onCompleted)

        expect(#onNext).to.equal(0)
        expect(onError).to.equal({{'ohno'}})
        expect(#onCompleted).to.equal(0)
      end)
    end)

    describe('if the AsyncSubject has not completed', function()
      it('returns a subscription', function()
        expect(Rx.AsyncSubject.create():subscribe()).to.be.an(Rx.Subscription)
      end)
    end)
  end)

  describe('onNext', function()
    it('does not push values to subscribers', function()
      local observer = Rx.Observer.create()
      local subject = Rx.AsyncSubject.create()
      local function run()
        subject:onNext(1)
        subject:onNext(2)
        subject:onNext(3)
      end

      expect(#spy(observer, '_onNext', run)).to.equal(0)
    end)
  end)

  describe('onError', function()
    it('pushes errors to all subscribers', function()
      local observers = {
        Rx.Observer.create(nil, function() end),
        Rx.Observer.create(nil, function() end)
      }

      local spies = {
        spy(observers[1], '_onError'),
        spy(observers[2], '_onError')
      }

      local subject = Rx.AsyncSubject.create()
      subject:subscribe(observers[1])
      subject:subscribe(observers[2])

      subject:onError('ohno')

      expect(spies[1]).to.equal({{'ohno'}})
      expect(spies[2]).to.equal({{'ohno'}})
    end)
  end)

  describe('onCompleted', function()
    it('pushes the last value to all Observers if one is present then calls onCompleted', function()
      local observers = {}
      local spies = {}
      for i = 1, 2 do
        observers[i] = Rx.Observer.create()
        spies[i] = {}
        spies[i].onNext = spy(observers[i], '_onNext')
        spies[i].onError = spy(observers[i], '_onError')
        spies[i].onCompleted = spy(observers[i], '_onCompleted')
      end

      local subject = Rx.AsyncSubject.create()
      subject:subscribe(observers[1])
      subject:subscribe(observers[2])

      subject:onNext(1)
      subject:onNext(2)
      subject:onCompleted()

      for i = 1, 2 do
        expect(spies[i].onNext).to.equal({{2}})
        expect(#spies[i].onError).to.equal(0)
        expect(#spies[i].onCompleted).to.equal(1)
      end
    end)
  end)
end)
