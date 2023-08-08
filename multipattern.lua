local pattern_time = require 'pattern_time'

local multipattern = { _is_multipattern = true }

function multipattern.new(pattern)
    pattern = pattern or pattern_time.new()

    local mpat = setmetatable({}, { __index = multipattern })
    mpat.pattern = pattern
    mpat.actions = {}

    pattern.process = function(data)
        if type(mpat.actions[data.id]) == 'function' then
            mpat.actions[data.id](table.unpack(data.args))
        else
            print('multipattern: no process for the id '..id..'!')
        end
    end

    return mpat
end

local function add_action(self, id, action)
    if self.actions[id] then
        print('multipattern: the id '..id..' already exists!')
    else
        self.actions[id] = action
    end
end

-- add a process function. mpat can be either self, or a table of multiple instances
function multipattern.add_process(mpat, id, action)
    if mpat._is_multipattern then
        local self = mpat

        add_action(self, id, action)
    else
        local set = mpat

        for _,mp in pairs(set) do
            add_action(mp, id, action)
        end
    end
end

-- watch. mpat can be either self, or a table of multiple instances
function multipattern.watch(mpat, id, ...)
    if mpat._is_multipattern then
        local self = mpat

        self.pattern:watch({ id = id, args = { ... } })
    else
        local set = mpat

        for _,mp in pairs(set) do
            mp.pattern:watch({ id = id, args = { ... } })
        end
    end
end

-- wrap a function. mpat can be either self, or a table of multiple instances
function multipattern.wrap(mpat, id, action)
    if mpat._is_multipattern then
        local self = mpat

        add_action(self, id, action)

        return function(...)
            action(...)
            self.pattern:watch({ id = id, args = { ... } })
        end
    else
        local set = mpat

        for _,mp in pairs(set) do
            add_action(mp, id, action)
        end
        
        return function(...)
            action(...)
            for _,mp in pairs(set) do
                mp.pattern:watch({ id = id, args = { ... } })
            end
        end
    end
end

return multipattern
