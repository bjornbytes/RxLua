--- Horrible script to concatenate everything in /src into a single rx.lua file.
-- @usage lua tools/build.lua [distribution=base]
-- @arg {string='base'} distribution - Type of distribution to build, either 'base' or 'luvit'.

local files = {
  'src/util.lua',
  'src/subscription.lua',
  'src/observer.lua',
  'src/observable.lua',
  'src/operators/all.lua',
  'src/operators/amb.lua',
  'src/operators/average.lua',
  'src/operators/buffer.lua',
  'src/operators/catch.lua',
  'src/operators/combineLatest.lua',
  'src/operators/compact.lua',
  'src/operators/concat.lua',
  'src/operators/contains.lua',
  'src/operators/count.lua',
  'src/operators/debounce.lua',
  'src/operators/defaultIfEmpty.lua',
  'src/operators/delay.lua',
  'src/operators/distinct.lua',
  'src/operators/distinctUntilChanged.lua',
  'src/operators/elementAt.lua',
  'src/operators/filter.lua',
  'src/operators/find.lua',
  'src/operators/first.lua',
  'src/operators/flatMap.lua',
  'src/operators/flatMapLatest.lua',
  'src/operators/flatten.lua',
  'src/operators/ignoreElements.lua',
  'src/operators/last.lua',
  'src/operators/map.lua',
  'src/operators/max.lua',
  'src/operators/merge.lua',
  'src/operators/min.lua',
  'src/operators/pack.lua',
  'src/operators/partition.lua',
  'src/operators/pluck.lua',
  'src/operators/reduce.lua',
  'src/operators/reject.lua',
  'src/operators/retry.lua',
  'src/operators/sample.lua',
  'src/operators/scan.lua',
  'src/operators/skip.lua',
  'src/operators/skipLast.lua',
  'src/operators/skipUntil.lua',
  'src/operators/skipWhile.lua',
  'src/operators/startWith.lua',
  'src/operators/sum.lua',
  'src/operators/switch.lua',
  'src/operators/take.lua',
  'src/operators/takeLast.lua',
  'src/operators/takeUntil.lua',
  'src/operators/takeWhile.lua',
  'src/operators/tap.lua',
  'src/operators/unpack.lua',
  'src/operators/unwrap.lua',
  'src/operators/window.lua',
  'src/operators/with.lua',
  'src/operators/zip.lua',
  'src/schedulers/immediatescheduler.lua',
  'src/schedulers/cooperativescheduler.lua',
  'src/schedulers/timeoutscheduler.lua',
  'src/subjects/subject.lua',
  'src/subjects/asyncsubject.lua',
  'src/subjects/behaviorsubject.lua',
  'src/subjects/replaysubject.lua',
  'src/aliases.lua'
}

local header = [[
-- RxLua v0.0.2
-- https://github.com/bjornbytes/rxlua
-- MIT License

]]

local exports = [[
exports.name = 'bjornbytes/rx'
exports.version = '0.0.2'
exports.description = 'Reactive Extensions for Lua'
exports.license = 'MIT'
exports.author = { url = 'https://github.com/bjornbytes' }
exports.homepage = 'https://github.com/bjornbytes/rxlua'

]]

local footer = [[return {
  util = util,
  Subscription = Subscription,
  Observer = Observer,
  Observable = Observable,
  ImmediateScheduler = ImmediateScheduler,
  CooperativeScheduler = CooperativeScheduler,
  TimeoutScheduler = TimeoutScheduler,
  Subject = Subject,
  AsyncSubject = AsyncSubject,
  BehaviorSubject = BehaviorSubject,
  ReplaySubject = ReplaySubject
}]]

local output = ''

for _, filename in ipairs(files) do
  local file = io.open(filename)

  if not file then
    error('error opening "' .. filename .. '"')
  end

  local str = file:read('*all')
  file:close()

  str = '\n' .. str .. '\n'
  str = str:gsub('\n(local[^\n]+require.[^\n]+)', '')
  str = str:gsub('\n(return[^\n]+)', '')
  str = str:gsub('^%s+', ''):gsub('%s+$', '')
  output = output .. str .. '\n\n'
end

local distribution = arg[1] or 'base'
local destination, components

if distribution == 'base' then
  destination = 'rx.lua'
  components = { header, output, footer }
elseif distribution == 'luvit' then
  destination = 'rx-luvit.lua'
  components = { header, exports, output, footer }
else
  error('Invalid distribution specified.')
end

local file = io.open(destination, 'w')

if file then
  file:write(table.concat(components, ''))
  file:close()
end
