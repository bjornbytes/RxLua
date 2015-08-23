# Observer

Observers are simple objects that receive values from Observables.

---

#### `.create(onNext, onError, onComplete)`

Creates a new Observer.

Arguments:

- `[onNext]` (`function`) - Called when the Observable produces a value.
- `[onError]` (`function`) - Called when the Observable terminates due to an error.
- `[onComplete]` (`function`) - Called when the Observable completes normally.

Returns:

- `Observer`

---

#### `:onNext(value)`

Pushes a new value to the Observer.

Arguments:

- `value` (`*`)

---

#### `:onError(message)`

Notify the Observer that an error has occurred.

Arguments:

- `[message]` (`string`) - A string describing what went wrong.

---

#### `:onComplete()`

Notify the Observer that the sequence has completed and will produce no more values.

# Observable

Observables push values to Observers.

---

#### `.create(subscribe)`

Creates a new Observable.

Arguments:

- `subscribe` (`function`) - The subscription function that produces values.

Returns:

- `Observable`

---

#### `.fromValue(value)`

Creates an Observable that produces a single value.

Arguments:

- `value` (`*`)

Returns:

- `Observable`

---

#### `.fromCoroutine(coroutine)`

Creates an Observable that produces values when the specified coroutine yields.

Arguments:

- `coroutine` (`thread`)

Returns:

- `Observable`

---

#### `:subscribe(onNext, onError, onComplete)`

Shorthand for creating an Observer and passing it to this Observable's subscription function.

Arguments:

- `onNext` (`function`) - Called when the Observable produces a value.
- `onError` (`function`) - Called when the Observable terminates due to an error.
- `onComplete` (`function`) - Called when the Observable completes normally.

---

#### `:dump(name)`

Subscribes to this Observable and prints values it produces.

Arguments:

- `[name]` (`string`) - Prefixes the printed messages with a name.

---

#### `:first()`

Returns a new Observable that only produces the first result of the original.

Returns:

- `Observable`

---

#### `:last()`

Returns a new Observable that only produces the last result of the original.

Returns:

- `Observable`

---

#### `:map(callback)`

Returns a new Observable that produces the values of the original transformed by a function.

Arguments:

- `callback` (`function`) - The function to transform values from the original Observable.

Returns:

- `Observable`

---

#### `:reduce(accumulator, seed)`

Returns a new Observable that produces a single value computed by accumulating the results of running a function on each value produced by the original Observable.

Arguments:

- `accumulator` (`function`) - Accumulates the values of the original Observable. Will be passed the return value of the last call as the first argument and the current value as the second.
- `seed` (`*`) - A value to pass to the accumulator the first time it is run.

Returns:

- `Observable`

---

#### `:sum()`

Returns a new Observable that produces the sum of the values of the original Observable as a single result.

Returns:

- `Observable`

---

#### `:combineLatest(observables, combinator)`

Returns a new Observable that runs a combinator function on the most recent values from a set of Observables whenever any of them produce a new value. The results of the combinator function are produced by the new Observable.

Arguments:

- `observables` (`Observable...`) - One or more Observables to combine.
- `combinator` (`function`) - A function that combines the latest result from each Observable and returns a single value.

Returns:

- `Observable`

---

#### `:distinct()`

Returns a new Observable that produces the values from the original with duplicates removed.

Returns:

- `Observable`

# Scheduler

Schedulers manage groups of Observables.

# CooperativeScheduler

Manages Observables using coroutines and a virtual clock that must be updated manually.

---

#### `.create(currentTime)`

Creates a new Cooperative Scheduler.

Arguments:

- `[currentTime=0]` (`number`) - A time to start the scheduler at.

Returns:

- `Scheduler.Cooperative`

---

#### `:schedule(action, delay)`

Schedules a function to be run after an optional delay.

Arguments:

- `action` (`function`) - The function to execute. Will be converted into a coroutine. The coroutine may yield execution back to the scheduler with an optional number, which will put it to sleep for a time period.
- `[delay=0]` (`number`) - Delay execution of the action by a time period.

---

#### `:update(delta)`

Triggers an update of the Cooperative Scheduler. The clock will be advanced and the scheduler will run any coroutines that are due to be run.

Arguments:

- `[delta=0]` (`number`) - An amount of time to advance the clock by. It is common to pass in the time in seconds or milliseconds elapsed since this function was last called.

---

#### `:isEmpty()`

Returns whether or not the Cooperative Scheduler's queue is empty.

