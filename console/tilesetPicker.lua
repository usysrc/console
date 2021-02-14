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
    File: tilesetPicker.lua
    Description: click to select a sprite
]]--

--[[
    Utilities
]]--
local setColor = require("funcs.setColor")

--[[
    Components
]]--
local palette = require("console.palette")
local sprites = require("console.sprites")

--[[
    Private
]]--
local tilesetPicker = {}

local console
local selectedTile
local tilesetCanvas = love.graphics.newCanvas()
local tilesetOffsetX, tilesetOffsetY = 22, 180
local tilesetWidth = 16
local tilesetHeight = 4
local w = 16
local h = 16

local drawTiles = function()
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    
    for i=0, (tilesetWidth*tilesetHeight)-1 do
        local sprite = sprites.get(i)
        if sprite then
            setColor(255,255,255)
            love.graphics.draw(sprite, ox+(i%(tilesetWidth))*w, oy+(math.floor(i/tilesetWidth))*h)
        end
    end
    for i=0, (tilesetWidth*tilesetHeight)-1 do
        setColor(50,50,50)
        love.graphics.rectangle("line", ox+(i%(tilesetWidth))*w, oy+(math.floor(i/tilesetWidth))*h, w, h)
    end
end

local drawTilesetMarker = function()
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    love.graphics.setLineWidth(2)
    for i=0, (tilesetWidth*tilesetHeight)-1 do
        if i == selectedTile then
            setColor(255,255,255)
            love.graphics.rectangle("line", ox+(i%tilesetWidth)*w, oy+(math.floor(i/tilesetWidth))*h, w, h)
        end
    end
    love.graphics.setLineWidth(1)
end

local clickTileset = function(mx,my,btn)
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    for i = 0, (tilesetWidth*tilesetHeight)-1 do
        if mx > ox+(i%tilesetWidth)*w and mx < ox+(i%tilesetWidth)*h + w and my > oy+(math.floor(i/tilesetWidth))*h and my < oy+(math.floor(i/tilesetWidth))*h+h then
            selectedTile = i
        end
    end
end

local drawTileset = function()
    drawTiles()
    drawTilesetMarker()
end

--[[
    Public
]]--
tilesetPicker.update = function()
    --drawTilesetTilesToCanvas()
end

tilesetPicker.init = function(c)
    console = c
    selectedTile = 1
end

tilesetPicker.getTileWidth = function()
    return w
end

tilesetPicker.getTileHeight = function()
    return h
end

tilesetPicker.getOffsets = function()
    return ((selectedTile%tilesetWidth))*w, (math.floor(selectedTile/tilesetWidth))*h
end

tilesetPicker.draw = function()
    drawTileset()
end

tilesetPicker.click = function()
    clickTileset(love.mouse.getX(), love.mouse.getY(), 1)
end

tilesetPicker.getSelectedTileID = function()
    return selectedTile
end

return tilesetPicker