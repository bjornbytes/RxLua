-- Horrible script to concatenate everything in /src into a single rx.lua file.
-- Usage: lua tools/concat.lua [dest=rx.lua]

local files = {
  'src/util.lua',
  'src/subscription.lua',
  'src/observer.lua',
  'src/observable.lua',
  'src/schedulers/immediatescheduler.lua',
  'src/schedulers/cooperativescheduler.lua',
  'src/subjects/subject.lua',
  'src/subjects/behaviorsubject.lua'
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
