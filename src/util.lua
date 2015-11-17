local util = {}

util.pack = table.pack or function(...) return { n = select('#', ...), ... } end
util.unpack = table.unpack or unpack
util.eq = function(x, y) return x == y end
util.noop = function() end
util.identity = function(x) return x end
util.constant = function(x) return function() return x end end
util.isa = function(object, class)
  return type(object) == 'table' and getmetatable(object).__index == class
end
util.tryWithObserver = function(observer, fn, ...)
  return xpcall(fn, function(...)
    return observer:onError(...)
  end, ...)
end

return util
