local pattern_time = require 'pattern_time'

local multipattern = {}

function multipattern.new(pattern)
    pattern = pattern or pattern_time.new()

    local mpat = setmetatable({}, { __index = multipattern })
    mpat.pattern = pattern
    mpat.actions = {}

    pattern.process = function(data)
        mpat.actions[data.id](data.args)
    end

    return mpat
end

function multipattern:wrap(id, action)
    if self.actions[id] then
        console.log('multipattern: the id '..id..' already exists!')
    else
        self.actions[id] = action
    end

    return function(...)
        action(...)
        self.pattern:watch({ id = id, args = { ... } })
    end
end

return multipattern
