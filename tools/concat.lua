-- Horrible script to concatenate everything in /src into a single rx.lua file.
-- Usage: lua tools/concat.lua [dest=rx.lua]

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
  'src/operators/defaultIfEmpty.lua',
  'src/operators/distinct.lua',
  'src/operators/distinctUntilChanged.lua',
  'src/operators/filter.lua',
  'src/operators/find.lua',
  'src/operators/first.lua',
  'src/operators/flatten.lua',
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
  'src/operators/skip.lua',
  'src/operators/skipUntil.lua',
  'src/operators/skipWhile.lua',
  'src/operators/take.lua',
  'src/operators/takeUntil.lua',
  'src/operators/takeWhile.lua',
  'src/operators/tap.lua',
  'src/operators/unpack.lua',
  'src/operators/unwrap.lua',
  'src/operators/window.lua',
  'src/operators/with.lua',
  'src/schedulers/immediatescheduler.lua',
  'src/schedulers/cooperativescheduler.lua',
  'src/subjects/subject.lua',
  'src/subjects/behaviorsubject.lua',
  'src/aliases.lua'
}

local header = [[
-- RxLua v0.0.1
-- https://github.com/bjornbytes/rxlua
-- MIT License

]]

local footer = [[return {
  util = util,
  Subscription = Subscription,
  Observer = Observer,
  Observable = Observable,
  ImmediateScheduler = ImmediateScheduler,
  CooperativeScheduler = CooperativeScheduler,
  Subject = Subject,
  BehaviorSubject = BehaviorSubject
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

local outputFile = arg[1] or 'rx.lua'
local file = io.open(outputFile, 'w')
if file then
  file:write(header .. output .. footer)
end
