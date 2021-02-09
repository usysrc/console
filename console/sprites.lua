local palette = require("console.palette")

local sprites = {}

local storage = {}

sprites.get = function(idx)
    if not storage[idx] then
        local canvas = love.graphics.newCanvas(16,16)
        local c = love.graphics.getCanvas()
        love.graphics.setCanvas(canvas)
        local tx, ty = (idx%16), math.floor(idx/16)
        local t = console.pixelEditor.getTileset()["1,1"]
        for i=0, 15 do
            for j=0,15 do
                setColor(palette[t[(tx+i)..","..(ty+j+1)]])
                love.graphics.rectangle("fill", i, j, 1, 1)
            end
        end
        love.graphics.setCanvas(c)
        sprites.set(idx, canvas)
    end
    return storage[idx]
end

sprites.set = function(idx, c)
    storage[idx] = c
end

sprites.init = function()
    storage = {}
end

return sprites