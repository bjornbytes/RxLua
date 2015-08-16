
# Observer

Observers are simple objects that receive values from Observables.

#### `.create(onNext, onError, onComplete)`

Creates a new Observer.

#### `:onNext(value)`

Pushes a new value to the Observer.

#### `:onError(message)`

Notify the Observer that an error has occurred.

#### `:onComplete()`

Notify the Observer that the sequence has completed and will produce no more values.


# Observable

Observables push values to Observers.

#### `.create(subscribe)`

Creates a new Observable.

#### `.fromValue(value)`

Creates an Observable that produces a single value.

#### `.fromCoroutine(cr)`

Creates an Observable that produces values when the specified coroutine yields.

#### `:subscribe(onNext, onError, onComplete)`

Shorthand for creating an Observer and passing it to this Observable's subscription function.

#### `:dump(name)`

Subscribes to this Observable and prints values it produces.

#### `:first()`

Returns a new Observable that only produces the first result of the original.

#### `:last()`

Returns a new Observable that only produces the last result of the original.

#### `:map(callback)`

Returns a new Observable that produces the values of the original transformed by a function.

#### `:reduce(accumulator, seed)`

Returns a new Observable that produces a single value computed by accumulating the results of running a function on each value produced by the original Observable.

#### `:sum()`

Returns a new Observable that produces the sum of the values of the original Observable as a single result.

#### `:combineLatest(...)`

Returns a new Observable that runs a combinator function on the most recent values from a set of Observables whenever any of them produce a new value. The results of the combinator function are produced by the new Observable.

