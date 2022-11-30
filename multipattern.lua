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


-- wrap a function. mpat can be either self, or a table of multiple instances
function multipattern.wrap(mpat, id, action)
    if mpat.wrap then
        local self = mpat

        if self.actions[id] then
            print('multipattern: the id '..id..' already exists!')
        else
            self.actions[id] = action
        end

        return function(...)
            action(...)
            self.pattern:watch({ id = id, args = { ... } })
        end
    else
        local set = mpat

        for _,mp in pairs(set) do
            if mp.actions[id] then
                print('multipattern: the id '..id..' already exists!')
            else
                mp.actions[id] = action
            end
        end
        
        return function(...)
            action(...)
            for _,mp in pairs(set) do
                mp.pattern:watch({ id = id, args = { ... } })
            end
        end
    end
end

-- wrap a paramset, returns a table of wrapped param setter functions. mpat can be either self, or a table of multiple instances.
function multipattern.wrap_paramset(mpat, pset)
    pset = pset or params

    local set_param = {}

    for _,p in pairs(pset.params) do
        set_param[p.id] = multipattern.wrap(
            mpat, 
            p.id, 
            function(v) pset:set(p.id, v) end
        )
    end

    return set_param
end

return multipattern
