local setColor = require "funcs.setColor"

local palette = require("console.palette")

local TILESET_SIZE = 1024

local pixel = {}

local sprites = {}

local storage = {}

sprites.getData = function(x, y)
    return pixel[x..","..y]
end

sprites.setData = function(x, y, color)
    pixel[x..","..y] = color
end

sprites.getAllData = function()
    return pixel
end

sprites.setAllData = function(data)
    pixel = data
end

sprites.get = function(idx)
    if not storage[idx] then
        local canvas = love.graphics.newCanvas(16,16)
        local c = love.graphics.getCanvas()
        love.graphics.setCanvas(canvas)
        local tx, ty = (idx%16), math.floor(idx/16)
        for i=0, 15 do
            for j=0,15 do
                local p = pixel[(tx+i)..","..(ty+j+1)]
                if p then
                    setColor(palette[p])
                    love.graphics.rectangle("fill", i, j, 1, 1)
                end
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