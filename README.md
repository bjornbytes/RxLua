RxLua
===

How to use:

```lua
local Rx = require 'rx'

local observable = Rx.Observable.create(function(observer)
  observer.onNext(42)
end)

observable:subscribe(
  function(x)
    print('onNext: ' .. x)
  end,
  function(e)
    print('onError: ' .. e)
  end,
  function()
    print('Complete')
  end
)
```

See examples for more details.

Combinators
---

- `first`
- `last`
- `map`
- `reduce`
- `sum`
- `combineLatest`

License
---

MIT, see `LICENSE` for details.
