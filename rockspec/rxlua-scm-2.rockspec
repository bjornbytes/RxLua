package = "rxlua"
version = "scm-2"

source = { url = "git://github.com/bjornbytes/RxLua.git" }

description =
{
  summary = "Reactive Extensions for Lua",
  homepage = "https://github.com/bjornbytes/RxLua/tree/master",
  license = "MIT/X11",
  maintainer = "tie.372@gmail.com",
  detailed = [[
RxLua gives Lua the power of Observables, which are data structures that represent a stream of values that arrive over time. They're very handy when dealing with events, streams of data, asynchronous requests, and concurrency.
]]
}

dependencies = { "lua >= 5.1" }

build =
{
  type = "builtin",
  modules = { rx = "rx.lua", },
  copy_directories = { "doc", "tests" }
}
