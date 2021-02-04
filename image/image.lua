local memo = function(fn)
    local mem = {}
    return function(a)
        if not mem[a] then
            mem[a] = fn(a)
        end
        return mem[a]
    end
end

local dir = "img/"
local ext = ".png"

local image = memo(function(name)
    return love.graphics.newImage(dir..name..ext)
end)

return image