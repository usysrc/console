--[[
Copyright (c) 2021, usysrc

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]--

--[[
    File: sprites.lua
    Description: contains all pixels
]]--

--[[
    Utilities
]]--
local setColor = require "funcs.setColor"

--[[
    Components
]]--
local palette = require("console.palette")

--[[
    Private
]]--
local TILESET_SIZE = 1024
local pixel = {}
local storage = {}

--[[
    Public
]]--
local sprites = {}

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