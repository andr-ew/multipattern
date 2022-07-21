local pattern_time = require 'pattern_time'

local multipattern = {}

function multipattern.new(pattern)
    pattern = pattern or pattern_time.new()

    local mpat = setmetatable({}, { __index = multipattern })
    mpat.pattern = pattern
    mpat.actions = {}

    pattern.process = function(data)
        if type(mpat.actions[data.id]) == 'function' then
            mpat.actions[data.id](table.unpack(data.args))
        end
    end

    return mpat
end

-- wrap one function in one pattern
function multipattern:wrap(id, action)
    if self.actions[id] then
        print('multipattern: the id '..id..' already exists!')
    else
        self.actions[id] = action
    end

    return function(...)
        action(...)
        self.pattern:watch({ id = id, args = { ... } })
    end
end

-- wrap one function in multiple patterns
function multipattern.wrap_set(set, id, action)
    for _,mp in ipairs(set) do
        if mp.actions[id] then
            print('multipattern: the id '..id..' already exists!')
        else
            mp.actions[id] = action
        end
    end
    
    return function(...)
        action(...)
        for _,mp in ipairs(set) do
            mp.pattern:watch({ id = id, args = { ... } })
        end
    end
end

return multipattern
