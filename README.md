RxLua
===

[Reactive Extensions](http://reactivex.io) for Lua.

Examples
---

Cheer someone on using functional reactive programming:

```lua
local Rx = require 'rx'

local observable = Rx.Observable.fromCoroutine(function()
  for i = 2, 8, 2 do
    coroutine.yield(i)
  end

  return 'who do we appreciate'
end)

observable
  :map(function(value) return value .. '!' end)
  :subscribe(print)

repeat
  Rx.scheduler:update()
until Rx.scheduler:isEmpty()
```

See [examples](examples) for more.

Documentation
---

See [here](doc).

License
---

MIT, see [`LICENSE`](LICENSE) for details.
