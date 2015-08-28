RxLua
===

[Reactive Extensions](http://reactivex.io) for Lua.

Examples
---

Cheer someone on using functional reactive programming:

```lua
local Rx = require 'rx'

Rx.Observable.fromRange(2, 8, 2)
  :concat(Rx.Observable.fromValue('who do we appreciate'))
  :map(function(value) return value .. '!' end)
  :subscribe(print)
```

See [examples](examples) for more.

Documentation
---

See [here](doc).

License
---

MIT, see [`LICENSE`](LICENSE) for details.
