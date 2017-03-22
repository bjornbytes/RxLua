local docroc = require 'tools/docroc'

io.output('doc/README.md')

io.write('RxLua\n===\n\n')

local comments = docroc.process('rx.lua')

-- Generate table of contents
for _, comment in ipairs(comments) do
  local tags = comment.tags

  if tags.class then
    local class = tags.class[1].text
    io.write('- [' .. class .. '](#' .. class:lower() .. ')\n')
  else
    local context = comment.context:match('function.-([:%.].+)')
    if tags.arg then
      context = context:gsub('%b()', function(signature)
        local args = {}

        for _, arg in ipairs(tags.arg) do
          table.insert(args, arg.name)
        end

        return '(' .. table.concat(args, ', ') .. ')'
      end)
    end

    local name = comment.context:match('function.-[:%.]([^%(]+)')

    io.write('  - [' .. name .. '](#' .. context:gsub('[^%w%s]+', ''):gsub(' ', '-'):lower() .. ')\n')
  end
end

io.write('\n')

-- Generate content
for _, comment in ipairs(comments) do
  local tags = comment.tags

  if tags.class then
    io.write('# ' .. tags.class[1].text .. '\n\n')
    if tags.description then
      io.write(tags.description[1].text .. '\n\n')
    end
  else
    local context = comment.context:match('function.-([:%.].+)')
    if tags.arg then
      context = context:gsub('%b()', function(signature)
        local args = {}

        for _, arg in ipairs(tags.arg) do
          table.insert(args, arg.name)
        end

        return '(' .. table.concat(args, ', ') .. ')'
      end)

    end

    io.write(('---\n\n#### `%s`\n\n'):format(context))

    if tags.description then
      io.write(('%s\n\n'):format(tags.description[1].text))
    end

    if tags.arg then
      io.write('| Name | Type | Default | Description |\n')
      io.write('|------|------|---------|-------------|\n')

      for _, arg in ipairs(tags.arg) do
        local name = arg.name
        name = '`' .. name .. '`'
        local description = arg.description or ''
        local type = arg.type:gsub('|', ' or ')
        local default = ''
        if arg.optional then
          type = type .. ' (optional)'
          default = arg.default or default
        end
        local line = '| ' .. name .. ' | ' .. type .. ' | ' .. default .. ' | ' .. description .. ' |'
        io.write(line .. '\n')
      end

      io.write('\n')
    end
  end
end
