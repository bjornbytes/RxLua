describe('Observable', function()
  describe('create', function()
    it('returns an Observable', function()
      local observable = Rx.Observable.create()
      expect(observable).to.be.an(Rx.Observable)
    end)

    it('sets _subscribe to the first argument it was passed', function()
      local subscribe = function() end
      local observable = Rx.Observable.create(subscribe)
      expect(observable._subscribe).to.equal(subscribe)
    end)
  end)

  describe('subscribe', function()
    it('passes the first argument to _subscribe if it is a table', function()
      local observable = Rx.Observable.fromValue()
      local observer = Rx.Observer.create()
      local function run() observable:subscribe(observer) end
      expect(spy(observable, '_subscribe', run)).to.equal({{observer}})
    end)

    it('creates a new Observer using the first three arguments and passes it to _subscribe if the first argument is not a table', function()
      local observable = Rx.Observable.fromValue()
      local a, b, c = function() end, function() end, function() end
      local function run() observable:subscribe(a, b, c) end
      local observer = spy(observable, '_subscribe', run)[1][1]
      expect(observer).to.be.an(Rx.Observer)
      expect(observer._onNext).to.equal(a)
      expect(observer._onError).to.equal(b)
      expect(observer._onComplete).to.equal(c)
    end)
  end)

  describe('fromValue', function()
    it('returns an Observable that produces the first argument and completes', function()
      local observable = Rx.Observable.fromValue(1, 2, 3)
      expect(observable).to.produce(1)
    end)

    it('returns an Observable that produces nil and completes if no arguments are passed', function()
      local observable = Rx.Observable.fromValue()
      expect(observable).to.produce(nil)
    end)
  end)

  describe('fromRange', function()
    it('errors if no arguments are provided', function()
      local run = function() Rx.Observable.fromRange():subscribe() end
      expect(run).to.fail()
    end)

    describe('with one argument', function()
      it('returns an Observable that produces elements sequentially from 1 to the first argument', function()
        local observable = Rx.Observable.fromRange(5)
        expect(observable).to.produce(1, 2, 3, 4, 5)
      end)

      it('returns an Observable that produces no elements if the first argument is less than one', function()
        local observable = Rx.Observable.fromRange(0)
        expect(observable).to.produce.nothing()
      end)
    end)

    describe('with two arguments', function()
      it('returns an Observable that produces elements sequentially from the first argument to the second argument', function()
        local observable = Rx.Observable.fromRange(1, 5)
        expect(observable).to.produce(1, 2, 3, 4, 5)
      end)

      it('returns an Observable that produces no elements if the first argument is greater than the second argument', function()
        local observable = Rx.Observable.fromRange(1, -5)
        expect(observable).to.produce.nothing()
      end)
    end)

    describe('with three arguments', function()
      it('returns an Observable that produces elements sequentially from the first argument to the second argument, incrementing by the third argument', function()
        local observable = Rx.Observable.fromRange(1, 5, 2)
        expect(observable).to.produce(1, 3, 5)
      end)
    end)
  end)

  describe('fromTable', function()
    it('errors if the first argument is not a table', function()
      local function run() Rx.Observable.fromTable():subscribe() end
      expect(run).to.fail()
    end)

    describe('with one argument', function()
      it('returns an Observable that produces values by iterating the table using pairs', function()
        local input = {foo = 'bar', 1, 2, 3}
        local observable = Rx.Observable.fromTable(input)
        local result = {}
        for key, value in pairs(input) do table.insert(result, {value}) end
        expect(observable).to.produce(result)
      end)
    end)

    describe('with two arguments', function()
      it('returns an Observable that produces values by iterating the table using the second argument', function()
        local input = {foo = 'bar', 3, 4, 5}
        local observable = Rx.Observable.fromTable(input, ipairs)
        expect(observable).to.produce(3, 4, 5)
      end)
    end)

    describe('with three arguments', function()
      it('returns an Observable that produces value-key pairs by iterating the table if the third argument is true', function()
        local input = {foo = 'bar', 3, 4, 5}
        local observable = Rx.Observable.fromTable(input, ipairs, true)
        expect(observable).to.produce({{3, 1}, {4, 2}, {5, 3}})
      end)
    end)
  end)

  describe('fromCoroutine', function()
    it('returns an Observable that produces a value whenever the first argument yields a value', function()
      local coroutine = coroutine.create(function()
        coroutine.yield(1)
        coroutine.yield(2)
        return 3
      end)

      Rx.scheduler = Rx.Scheduler.Cooperative.create()
      local observable = Rx.Observable.fromCoroutine(coroutine)
      local onNext, onError, onComplete = observableSpy(observable)
      repeat Rx.scheduler:update()
      until Rx.scheduler:isEmpty()
      expect(onNext).to.equal({{1}, {2}, {3}})
    end)

    it('accepts a function as the first argument and wraps it into a coroutine', function()
      local coroutine = function()
        coroutine.yield(1)
        coroutine.yield(2)
        return 3
      end

      Rx.scheduler = Rx.Scheduler.Cooperative.create()
      local observable = Rx.Observable.fromCoroutine(coroutine)
      local onNext, onError, onComplete = observableSpy(observable)
      repeat Rx.scheduler:update()
      until Rx.scheduler:isEmpty()
      expect(onNext).to.equal({{1}, {2}, {3}})
    end)
  end)

  describe('dump', function()
  end)

  dofile('tests/changes.lua')
  dofile('tests/combine.lua')
  dofile('tests/compact.lua')
  dofile('tests/concat.lua')
  dofile('tests/distinct.lua')
  dofile('tests/filter.lua')
end)
