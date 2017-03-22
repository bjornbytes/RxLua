RxLua
===

- [Subscription](#subscription)
  - [create](#createaction)
  - [unsubscribe](#unsubscribe)
- [Observer](#observer)
  - [create](#createonnext-onerror-oncompleted)
  - [onNext](#onnextvalues)
  - [onError](#onerrormessage)
  - [onCompleted](#oncompleted)
- [Observable](#observable)
  - [create](#createsubscribe)
  - [subscribe](#subscribeonnext-onerror-oncompleted)
  - [empty](#empty)
  - [never](#never)
  - [throw](#throwmessage)
  - [of](#ofvalues)
  - [fromRange](#fromrangeinitial-limit-step)
  - [fromTable](#fromtabletable-iterator-keys)
  - [fromCoroutine](#fromcoroutinefn)
  - [fromFileByLine](#fromfilebylinefilename)
  - [defer](#deferfactory)
  - [replicate](#replicatevalue-count)
  - [dump](#dumpname-formatter)
  - [all](#allpredicate)
  - [amb](#ambobservables)
  - [average](#average)
  - [buffer](#buffersize)
  - [catch](#catchhandler)
  - [combineLatest](#combinelatestobservables-combinator)
  - [compact](#compact)
  - [concat](#concatsources)
  - [contains](#containsvalue)
  - [count](#countpredicate)
  - [defaultIfEmpty](#defaultifemptyvalues)
  - [delay](#delaytime-scheduler)
  - [distinct](#distinct)
  - [distinctUntilChanged](#distinctuntilchangedcomparator)
  - [elementAt](#elementatindex)
  - [filter](#filterpredicate)
  - [find](#findpredicate)
  - [first](#first)
  - [flatMap](#flatmapcallback)
  - [flatMapLatest](#flatmaplatestcallback)
  - [flatten](#flatten)
  - [ignoreElements](#ignoreelements)
  - [last](#last)
  - [map](#mapcallback)
  - [max](#max)
  - [merge](#mergesources)
  - [min](#min)
  - [pack](#pack)
  - [partition](#partitionpredicate)
  - [pluck](#pluckkeys)
  - [reduce](#reduceaccumulator-seed)
  - [reject](#rejectpredicate)
  - [retry](#retrycount)
  - [sample](#samplesampler)
  - [scan](#scanaccumulator-seed)
  - [skip](#skipn)
  - [skipLast](#skiplastcount)
  - [skipUntil](#skipuntilother)
  - [skipWhile](#skipwhilepredicate)
  - [startWith](#startwithvalues)
  - [sum](#sum)
  - [switch](#switch)
  - [take](#taken)
  - [takeLast](#takelastcount)
  - [takeUntil](#takeuntilother)
  - [takeWhile](#takewhilepredicate)
  - [tap](#taponnext-onerror-oncompleted)
  - [unpack](#unpack)
  - [unwrap](#unwrap)
  - [window](#windowsize)
  - [with](#withsources)
  - [zip](#zipsources)
- [ImmediateScheduler](#immediatescheduler)
  - [create](#create)
  - [schedule](#scheduleaction)
- [CooperativeScheduler](#cooperativescheduler)
  - [create](#createcurrenttime)
  - [schedule](#scheduleaction-delay)
  - [update](#updatedelta)
  - [isEmpty](#isempty)
- [TimeoutScheduler](#timeoutscheduler)
  - [create](#create)
  - [schedule](#scheduleaction-delay)
- [Subject](#subject)
  - [create](#create)
  - [subscribe](#subscribeonnext-onerror-oncompleted)
  - [onNext](#onnextvalues)
  - [onError](#onerrormessage)
  - [onCompleted](#oncompleted)
- [AsyncSubject](#asyncsubject)
  - [create](#create)
  - [subscribe](#subscribeonnext-onerror-oncompleted)
  - [onNext](#onnextvalues)
  - [onError](#onerrormessage)
  - [onCompleted](#oncompleted)
- [BehaviorSubject](#behaviorsubject)
  - [create](#createvalue)
  - [subscribe](#subscribeonnext-onerror-oncompleted)
  - [onNext](#onnextvalues)
  - [getValue](#getvalue)
- [ReplaySubject](#replaysubject)
  - [create](#createbuffersize)
  - [subscribe](#subscribeonnext-onerror-oncompleted)
  - [onNext](#onnextvalues)

# Subscription

A handle representing the link between an Observer and an Observable, as well as any work required to clean up after the Observable completes or the Observer unsubscribes.

---

#### `.create(action)`

Creates a new Subscription.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `action` | function (optional) |  | The action to run when the subscription is unsubscribed. It will only be run once. |

---

#### `:unsubscribe()`

Unsubscribes the subscription, performing any necessary cleanup work.

# Observer

Observers are simple objects that receive values from Observables.

---

#### `.create(onNext, onError, onCompleted)`

Creates a new Observer.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function (optional) |  | Called when the Observable produces a value. |
| `onError` | function (optional) |  | Called when the Observable terminates due to an error. |
| `onCompleted` | function (optional) |  | Called when the Observable completes normally. |

---

#### `:onNext(values)`

Pushes zero or more values to the Observer.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  |  |

---

#### `:onError(message)`

Notify the Observer that an error has occurred.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `message` | string (optional) |  | A string describing what went wrong. |

---

#### `:onCompleted()`

Notify the Observer that the sequence has completed and will produce no more values.

# Observable

Observables push values to Observers.

---

#### `.create(subscribe)`

Creates a new Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `subscribe` | function |  | The subscription function that produces values. |

---

#### `:subscribe(onNext, onError, onCompleted)`

Shorthand for creating an Observer and passing it to this Observable's subscription function.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function |  | Called when the Observable produces a value. |
| `onError` | function |  | Called when the Observable terminates due to an error. |
| `onCompleted` | function |  | Called when the Observable completes normally. |

---

#### `.empty()`

Returns an Observable that immediately completes without producing a value.

---

#### `.never()`

Returns an Observable that never produces values and never completes.

---

#### `.throw(message)`

Returns an Observable that immediately produces an error.

---

#### `.of(values)`

Creates an Observable that produces a set of values.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  |  |

---

#### `.fromRange(initial, limit, step)`

Creates an Observable that produces a range of values in a manner similar to a Lua for loop.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `initial` | number |  | The first value of the range, or the upper limit if no other arguments are specified. |
| `limit` | number (optional) |  | The second value of the range. |
| `step` | number (optional) | 1 | An amount to increment the value by each iteration. |

---

#### `.fromTable(table, iterator, keys)`

Creates an Observable that produces values from a table.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `table` | table |  | The table used to create the Observable. |
| `iterator` | function (optional) | pairs | An iterator used to iterate the table, e.g. pairs or ipairs. |
| `keys` | boolean |  | Whether or not to also emit the keys of the table. |

---

#### `.fromCoroutine(fn)`

Creates an Observable that produces values when the specified coroutine yields.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `fn` | thread or function |  | A coroutine or function to use to generate values.  Note that if a coroutine is used, the values it yields will be shared by all subscribed Observers (influenced by the Scheduler), whereas a new coroutine will be created for each Observer when a function is used. |

---

#### `.fromFileByLine(filename)`

Creates an Observable that produces values from a file, line by line.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `filename` | string |  | The name of the file used to create the Observable |

---

#### `.defer(factory)`

Creates an Observable that creates a new Observable for each observer using a factory function.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `factory` | function |  | A function that returns an Observable. |

---

#### `.replicate(value, count)`

Returns an Observable that repeats a value a specified number of times.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `value` | * |  | The value to repeat. |
| `count` | number (optional) |  | The number of times to repeat the value.  If left unspecified, the value is repeated an infinite number of times. |

---

#### `:dump(name, formatter)`

Subscribes to this Observable and prints values it produces.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string (optional) |  | Prefixes the printed messages with a name. |
| `formatter` | function (optional) | tostring | A function that formats one or more values to be printed. |

---

#### `:all(predicate)`

Determine whether all items emitted by an Observable meet some criteria.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function (optional) | identity | The predicate used to evaluate objects. |

---

#### `.amb(observables)`

Given a set of Observables, produces values from only the first one to produce a value.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `observables` | Observable... |  |  |

---

#### `:average()`

Returns an Observable that produces the average of all values produced by the original.

---

#### `:buffer(size)`

Returns an Observable that buffers values from the original and produces them as multiple values.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `size` | number |  | The size of the buffer. |

---

#### `:catch(handler)`

Returns an Observable that intercepts any errors from the previous and replace them with values produced by a new Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `handler` | function or Observable |  | An Observable or a function that returns an Observable to replace the source Observable in the event of an error. |

---

#### `:combineLatest(observables, combinator)`

Returns a new Observable that runs a combinator function on the most recent values from a set of Observables whenever any of them produce a new value. The results of the combinator function are produced by the new Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `observables` | Observable... |  | One or more Observables to combine. |
| `combinator` | function |  | A function that combines the latest result from each Observable and returns a single value. |

---

#### `:compact()`

Returns a new Observable that produces the values of the first with falsy values removed.

---

#### `:concat(sources)`

Returns a new Observable that produces the values produced by all the specified Observables in the order they are specified.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `sources` | Observable... |  | The Observables to concatenate. |

---

#### `:contains(value)`

Returns a new Observable that produces a single boolean value representing whether or not the specified value was produced by the original.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `value` | * |  | The value to search for.  == is used for equality testing. |

---

#### `:count(predicate)`

Returns an Observable that produces a single value representing the number of values produced by the source value that satisfy an optional predicate.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function (optional) |  | The predicate used to match values. |

---

#### `:defaultIfEmpty(values)`

Returns a new Observable that produces a default set of items if the source Observable produces no values.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  | Zero or more values to produce if the source completes without emitting anything. |

---

#### `:delay(time, scheduler)`

Returns a new Observable that produces the values of the original delayed by a time period.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `time` | number or function |  | An amount in milliseconds to delay by, or a function which returns this value. |
| `scheduler` | Scheduler |  | The scheduler to run the Observable on. |

---

#### `:distinct()`

Returns a new Observable that produces the values from the original with duplicates removed.

---

#### `:distinctUntilChanged(comparator)`

Returns an Observable that only produces values from the original if they are different from the previous value.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `comparator` | function |  | A function used to compare 2 values. If unspecified, == is used. |

---

#### `:elementAt(index)`

Returns an Observable that produces the nth element produced by the source Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `index` | number |  | The index of the item, with an index of 1 representing the first. |

---

#### `:filter(predicate)`

Returns a new Observable that only produces values of the first that satisfy a predicate.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function |  | The predicate used to filter values. |

---

#### `:find(predicate)`

Returns a new Observable that produces the first value of the original that satisfies a predicate.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function |  | The predicate used to find a value. |

---

#### `:first()`

Returns a new Observable that only produces the first result of the original.

---

#### `:flatMap(callback)`

Returns a new Observable that transform the items emitted by an Observable into Observables, then flatten the emissions from those into a single Observable

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `callback` | function |  | The function to transform values from the original Observable. |

---

#### `:flatMapLatest(callback)`

Returns a new Observable that uses a callback to create Observables from the values produced by the source, then produces values from the most recent of these Observables.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `callback` | function (optional) | identity | The function used to convert values to Observables. |

---

#### `:flatten()`

Returns a new Observable that subscribes to the Observables produced by the original and produces their values.

---

#### `:ignoreElements()`

Returns an Observable that terminates when the source terminates but does not produce any elements.

---

#### `:last()`

Returns a new Observable that only produces the last result of the original.

---

#### `:map(callback)`

Returns a new Observable that produces the values of the original transformed by a function.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `callback` | function |  | The function to transform values from the original Observable. |

---

#### `:max()`

Returns a new Observable that produces the maximum value produced by the original.

---

#### `:merge(sources)`

Returns a new Observable that produces the values produced by all the specified Observables in the order they are produced.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `sources` | Observable... |  | One or more Observables to merge. |

---

#### `:min()`

Returns a new Observable that produces the minimum value produced by the original.

---

#### `:pack()`

Returns an Observable that produces the values of the original inside tables.

---

#### `:partition(predicate)`

Returns two Observables: one that produces values for which the predicate returns truthy for, and another that produces values for which the predicate returns falsy.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function |  | The predicate used to partition the values. |

---

#### `:pluck(keys)`

Returns a new Observable that produces values computed by extracting the given keys from the tables produced by the original.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `keys` | string... |  | The key to extract from the table. Multiple keys can be specified to recursively pluck values from nested tables. |

---

#### `:reduce(accumulator, seed)`

Returns a new Observable that produces a single value computed by accumulating the results of running a function on each value produced by the original Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `accumulator` | function |  | Accumulates the values of the original Observable. Will be passed the return value of the last call as the first argument and the current values as the rest of the arguments. |
| `seed` | * |  | A value to pass to the accumulator the first time it is run. |

---

#### `:reject(predicate)`

Returns a new Observable that produces values from the original which do not satisfy a predicate.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function |  | The predicate used to reject values. |

---

#### `:retry(count)`

Returns an Observable that restarts in the event of an error.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `count` | number (optional) |  | The maximum number of times to retry.  If left unspecified, an infinite number of retries will be attempted. |

---

#### `:sample(sampler)`

Returns a new Observable that produces its most recent value every time the specified observable produces a value.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `sampler` | Observable |  | The Observable that is used to sample values from this Observable. |

---

#### `:scan(accumulator, seed)`

Returns a new Observable that produces values computed by accumulating the results of running a function on each value produced by the original Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `accumulator` | function |  | Accumulates the values of the original Observable. Will be passed the return value of the last call as the first argument and the current values as the rest of the arguments.  Each value returned from this function will be emitted by the Observable. |
| `seed` | * |  | A value to pass to the accumulator the first time it is run. |

---

#### `:skip(n)`

Returns a new Observable that skips over a specified number of values produced by the original and produces the rest.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `n` | number (optional) | 1 | The number of values to ignore. |

---

#### `:skipLast(count)`

Returns an Observable that omits a specified number of values from the end of the original Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `count` | number |  | The number of items to omit from the end. |

---

#### `:skipUntil(other)`

Returns a new Observable that skips over values produced by the original until the specified Observable produces a value.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `other` | Observable |  | The Observable that triggers the production of values. |

---

#### `:skipWhile(predicate)`

Returns a new Observable that skips elements until the predicate returns falsy for one of them.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function |  | The predicate used to continue skipping values. |

---

#### `:startWith(values)`

Returns a new Observable that produces the specified values followed by all elements produced by the source Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  | The values to produce before the Observable begins producing values normally. |

---

#### `:sum()`

Returns an Observable that produces a single value representing the sum of the values produced by the original.

---

#### `:switch()`

Given an Observable that produces Observables, returns an Observable that produces the values produced by the most recently produced Observable.

---

#### `:take(n)`

Returns a new Observable that only produces the first n results of the original.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `n` | number (optional) | 1 | The number of elements to produce before completing. |

---

#### `:takeLast(count)`

Returns an Observable that produces a specified number of elements from the end of a source Observable.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `count` | number |  | The number of elements to produce. |

---

#### `:takeUntil(other)`

Returns a new Observable that completes when the specified Observable fires.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `other` | Observable |  | The Observable that triggers completion of the original. |

---

#### `:takeWhile(predicate)`

Returns a new Observable that produces elements until the predicate returns falsy.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `predicate` | function |  | The predicate used to continue production of values. |

---

#### `:tap(onNext, onError, onCompleted)`

Runs a function each time this Observable has activity. Similar to subscribe but does not create a subscription.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function (optional) |  | Run when the Observable produces values. |
| `onError` | function (optional) |  | Run when the Observable encounters a problem. |
| `onCompleted` | function (optional) |  | Run when the Observable completes. |

---

#### `:unpack()`

Returns an Observable that unpacks the tables produced by the original.

---

#### `:unwrap()`

Returns an Observable that takes any values produced by the original that consist of multiple return values and produces each value individually.

---

#### `:window(size)`

Returns an Observable that produces a sliding window of the values produced by the original.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `size` | number |  | The size of the window. The returned observable will produce this number of the most recent values as multiple arguments to onNext. |

---

#### `:with(sources)`

Returns an Observable that produces values from the original along with the most recently produced value from all other specified Observables. Note that only the first argument from each source Observable is used.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `sources` | Observable... |  | The Observables to include the most recent values from. |

---

#### `.zip(sources)`

Returns an Observable that merges the values produced by the source Observables by grouping them by their index.  The first onNext event contains the first value of all of the sources, the second onNext event contains the second value of all of the sources, and so on.  onNext is called a number of times equal to the number of values produced by the Observable that produces the fewest number of values.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `sources` | Observable... |  | The Observables to zip. |

# ImmediateScheduler

Schedules Observables by running all operations immediately.

---

#### `.create()`

Creates a new ImmediateScheduler.

---

#### `:schedule(action)`

Schedules a function to be run on the scheduler. It is executed immediately.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `action` | function |  | The function to execute. |

# CooperativeScheduler

Manages Observables using coroutines and a virtual clock that must be updated manually.

---

#### `.create(currentTime)`

Creates a new CooperativeScheduler.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `currentTime` | number (optional) | 0 | A time to start the scheduler at. |

---

#### `:schedule(action, delay)`

Schedules a function to be run after an optional delay.  Returns a subscription that will stop the action from running.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `action` | function |  | The function to execute. Will be converted into a coroutine. The coroutine may yield execution back to the scheduler with an optional number, which will put it to sleep for a time period. |
| `delay` | number (optional) | 0 | Delay execution of the action by a virtual time period. |

---

#### `:update(delta)`

Triggers an update of the CooperativeScheduler. The clock will be advanced and the scheduler will run any coroutines that are due to be run.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `delta` | number (optional) | 0 | An amount of time to advance the clock by. It is common to pass in the time in seconds or milliseconds elapsed since this function was last called. |

---

#### `:isEmpty()`

Returns whether or not the CooperativeScheduler's queue is empty.

# TimeoutScheduler

A scheduler that uses luvit's timer library to schedule events on an event loop.

---

#### `.create()`

Creates a new TimeoutScheduler.

---

#### `:schedule(action, delay)`

Schedules an action to run at a future point in time.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `action` | function |  | The action to run. |
| `delay` | number (optional) | 0 | The delay, in milliseconds. |

# Subject

Subjects function both as an Observer and as an Observable. Subjects inherit all Observable functions, including subscribe. Values can also be pushed to the Subject, which will be broadcasted to any subscribed Observers.

---

#### `.create()`

Creates a new Subject.

---

#### `:subscribe(onNext, onError, onCompleted)`

Creates a new Observer and attaches it to the Subject.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function or table |  | A function called when the Subject produces a value or an existing Observer to attach to the Subject. |
| `onError` | function |  | Called when the Subject terminates due to an error. |
| `onCompleted` | function |  | Called when the Subject completes normally. |

---

#### `:onNext(values)`

Pushes zero or more values to the Subject. They will be broadcasted to all Observers.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  |  |

---

#### `:onError(message)`

Signal to all Observers that an error has occurred.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `message` | string (optional) |  | A string describing what went wrong. |

---

#### `:onCompleted()`

Signal to all Observers that the Subject will not produce any more values.

# AsyncSubject

AsyncSubjects are subjects that produce either no values or a single value.  If multiple values are produced via onNext, only the last one is used.  If onError is called, then no value is produced and onError is called on any subscribed Observers.  If an Observer subscribes and the AsyncSubject has already terminated, the Observer will immediately receive the value or the error.

---

#### `.create()`

Creates a new AsyncSubject.

---

#### `:subscribe(onNext, onError, onCompleted)`

Creates a new Observer and attaches it to the AsyncSubject.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function or table |  | A function called when the AsyncSubject produces a value or an existing Observer to attach to the AsyncSubject. |
| `onError` | function |  | Called when the AsyncSubject terminates due to an error. |
| `onCompleted` | function |  | Called when the AsyncSubject completes normally. |

---

#### `:onNext(values)`

Pushes zero or more values to the AsyncSubject.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  |  |

---

#### `:onError(message)`

Signal to all Observers that an error has occurred.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `message` | string (optional) |  | A string describing what went wrong. |

---

#### `:onCompleted()`

Signal to all Observers that the AsyncSubject will not produce any more values.

# BehaviorSubject

A Subject that tracks its current value. Provides an accessor to retrieve the most recent pushed value, and all subscribers immediately receive the latest value.

---

#### `.create(value)`

Creates a new BehaviorSubject.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `value` | *... |  | The initial values. |

---

#### `:subscribe(onNext, onError, onCompleted)`

Creates a new Observer and attaches it to the BehaviorSubject. Immediately broadcasts the most recent value to the Observer.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function |  | Called when the BehaviorSubject produces a value. |
| `onError` | function |  | Called when the BehaviorSubject terminates due to an error. |
| `onCompleted` | function |  | Called when the BehaviorSubject completes normally. |

---

#### `:onNext(values)`

Pushes zero or more values to the BehaviorSubject. They will be broadcasted to all Observers.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  |  |

---

#### `:getValue()`

Returns the last value emitted by the BehaviorSubject, or the initial value passed to the constructor if nothing has been emitted yet.

# ReplaySubject

A Subject that provides new Subscribers with some or all of the most recently produced values upon subscription.

---

#### `.create(bufferSize)`

Creates a new ReplaySubject.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `bufferSize` | number (optional) |  | The number of values to send to new subscribers. If nil, an infinite buffer is used (note that this could lead to memory issues). |

---

#### `:subscribe(onNext, onError, onCompleted)`

Creates a new Observer and attaches it to the ReplaySubject. Immediately broadcasts the most contents of the buffer to the Observer.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `onNext` | function |  | Called when the ReplaySubject produces a value. |
| `onError` | function |  | Called when the ReplaySubject terminates due to an error. |
| `onCompleted` | function |  | Called when the ReplaySubject completes normally. |

---

#### `:onNext(values)`

Pushes zero or more values to the ReplaySubject. They will be broadcasted to all Observers.

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `values` | *... |  |  |

