describe('BehaviorSubject', function()
  describe('create', function()
    it('returns a BehaviorSubject', function()
      expect(Rx.BehaviorSubject.create()).to.be.an(Rx.BehaviorSubject)
    end)

    it('sets the initial value based on the arguments', function()
      local subject = Rx.BehaviorSubject.create(1, 2, 3)
      expect({subject:getValue()}).to.equal({1, 2, 3})
    end)
  end)

  describe('subscribe', function()
    it('returns a Subscription', function()
      local subject = Rx.BehaviorSubject.create()
      local observer = Rx.Observer.create()
      expect(subject:subscribe(observer)).to.be.an(Rx.Subscription)
    end)

    it('accepts 3 functions as arguments', function()
      local onNext, onCompleted = spy(), spy()
      local subject = Rx.BehaviorSubject.create()
      subject:subscribe(onNext, nil, onCompleted)
      subject:onNext(5)
      subject:onCompleted()
      expect(onNext).to.equal({{5}})
      expect(#onCompleted).to.equal(1)
    end)

    it('calls onNext with the current value', function()
      local subject = Rx.BehaviorSubject.create()
      local observer = Rx.Observer.create()
      local onNext = spy(observer, '_onNext')
      subject:onNext(5)
      subject:subscribe(observer)
      expect(onNext).to.equal({{5}})
    end)
  end)

  describe('onNext', function()
    it('pushes values to all subscribers', function()
      local observers = {}
      local spies = {}
      for i = 1, 2 do
        observers[i] = Rx.Observer.create()
        spies[i] = spy(observers[i], '_onNext')
      end

      local subject = Rx.BehaviorSubject.create()
      subject:subscribe(observers[1])
      subject:subscribe(observers[2])
      subject:onNext(1)
      subject:onNext(2)
      subject:onNext(3)
      expect(spies[1]).to.equal({{1}, {2}, {3}})
      expect(spies[2]).to.equal({{1}, {2}, {3}})
    end)

    it('can be called using function syntax', function()
      local observer = Rx.Observer.create()
      local subject = Rx.BehaviorSubject.create()
      local onNext = spy(observer, 'onNext')
      subject:subscribe(observer)
      subject(4)
      expect(#onNext).to.equal(1)
    end)

    it('sets the current value', function()
      local subject = Rx.BehaviorSubject.create()
      subject:onNext(1, 2, 3)
      expect({subject:getValue()}).to.equal({1, 2, 3})
      subject:onNext(4, 5, 6)
      expect({subject:getValue()}).to.equal({4, 5, 6})
    end)
  end)

  describe('onError', function()
    it('pushes errors to all subscribers', function()
      local observers = {}
      local spies = {}
      for i = 1, 2 do
        observers[i] = Rx.Observer.create(nil, function() end, nil)
        spies[i] = spy(observers[i], '_onError')
      end

      local subject = Rx.BehaviorSubject.create()
      subject:subscribe(observers[1])
      subject:subscribe(observers[2])
      subject:onError('ohno')
      expect(spies[1]).to.equal({{'ohno'}})
      expect(spies[2]).to.equal({{'ohno'}})
    end)
  end)

  describe('onCompleted', function()
    it('notifies all subscribers of completion', function()
      local observers = {}
      local spies = {}
      for i = 1, 2 do
        observers[i] = Rx.Observer.create(nil, function() end, nil)
        spies[i] = spy(observers[i], '_onCompleted')
      end

      local subject = Rx.BehaviorSubject.create()
      subject:subscribe(observers[1])
      subject:subscribe(observers[2])
      subject:onCompleted()
      expect(#spies[1]).to.equal(1)
      expect(#spies[2]).to.equal(1)
    end)
  end)
end)
