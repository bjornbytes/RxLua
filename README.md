RxLua
===

[![Build Status](https://travis-ci.org/bjornbytes/RxLua.svg)](https://travis-ci.org/bjornbytes/RxLua)

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

Related
---

- [RxLove](https://github.com/bjornbytes/RxLove)

License
---

MIT, see [`LICENSE`](LICENSE) for details.
