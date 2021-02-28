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
local pixel = {}
local storage = {}
local dirty = {}
local w,h = 16, 16

local setDirty = function(x,y)
    local tx, ty = math.floor(x/w), math.floor(y/h)
    dirty[tx+ty*16] = true
end

--[[
    Public
]]--
local sprites = {}

sprites.getData = function(x, y)
    return pixel[x..","..y]
end

sprites.setData = function(x, y, color)
    pixel[x..","..y] = color
    setDirty(x,y)
end

sprites.getAllData = function()
    return pixel
end

sprites.setAllData = function(data)
    pixel = data
end

sprites.get = function(idx)
    if not storage[idx] or dirty[idx] then
        local canvas = love.graphics.newCanvas(w, h)
        local c = love.graphics.getCanvas()
        love.graphics.setCanvas(canvas)
        local tx, ty = (idx%w)*w, math.floor(idx/w)*h
        for i=1, w do
            for j=1,h do
                local p = pixel[(tx+i)..","..(ty+j)]
                if p then
                    setColor(palette[p])
                    love.graphics.rectangle("fill", i-1, j-1, 1, 1)
                end
            end
        end
        love.graphics.setCanvas(c)
        sprites.set(idx, canvas)
        dirty[idx] = false
    end
    return storage[idx]
end

sprites.set = function(idx, c)
    storage[idx] = c
end

sprites.init = function()
    storage = {}
    for x = 1, 512 do
        for y = 1, 512 do
            if not pixel[x..","..y] then pixel[x..","..y] = 1 end
        end
    end
end

sprites.save = function()
    love.filesystem.createDirectory("export")
    for x=0,16 do
        for y=0,16 do
            local width, height = 16, 16
            local imageData = love.image.newImageData( width, height )
            local empty = true
            for i=0, width-1 do
                for j=0, height-1 do
                    local p = sprites.getData(x*16 + i+1,y*16+ j+1)
                    local col
                    if p then
                        col = palette[p]
                        empty = false
                    else
                        col = {255,255,255,0}
                    end
                    imageData:setPixel(i,j,col[1]/255, col[2]/255, col[3]/255, col[4] or 1)
                end
            end
            if not empty then
                imageData:encode('png', 'export/sprites_'..y..'-'..x..'.png')
            end
        end
    end
end

return sprites