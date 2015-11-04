RxLua [![Build Status](https://travis-ci.org/bjornbytes/RxLua.svg)](https://travis-ci.org/bjornbytes/RxLua)
===

[Reactive Extensions](http://reactivex.io) for Lua.

Examples
---

Cheer someone on using functional reactive programming:

```lua
local Rx = require 'rx'

Rx.Observable.fromRange(1, 4)
  :map(function(x) return x * 2 end)
  :concat(Rx.Observable.fromValue('who do we appreciate'))
  :map(function(value) return value .. '!' end)
  :subscribe(print)
```

See [examples](examples) for more.

Documentation
---

See [here](doc).

Contributing
---

See [here](doc/CONTRIBUTING.md).

Tests
---

Uses [lust](https://github.com/bjornbytes/lust). Run with:

```
lua tests/runner.lua
```

or, to run a specific test:

```
lua tests/runner.lua skipUntil
```

Related
---

- [Trello](https://trello.com/b/Q9dJicKK)
- [RxLove](https://github.com/bjornbytes/RxLove)

License
---

MIT, see [`LICENSE`](LICENSE) for details.
