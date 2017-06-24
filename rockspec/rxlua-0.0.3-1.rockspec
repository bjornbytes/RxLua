package = "rxlua"
version = "0.0.3-1"

source = {
  url = "git://github.com/bjornbytes/RxLua.git",
  tag = "v0.0.3"
}

description = {
  summary = "Reactive Extensions for Lua",
  homepage = "https://github.com/bjornbytes/RxLua",
  license = "MIT/X11",
  maintainer = "tie.372@gmail.com",
  detailed = [[
    RxLua gives Lua the power of Observables, which are data structures that represent a stream of values that arrive over time. They're very handy when dealing with events, streams of data, asynchronous requests, and concurrency.
  ]]
}

build = {
  type = "builtin",
  modules = { rx = "rx.lua", },
  copy_directories = { "doc", "tests" }
}
