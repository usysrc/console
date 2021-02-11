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
local tilesetOffsetX, tilesetOffsetY = 4, 164
local tilesetWidth = 14
local tilesetHeight = 4
local w = 16
local h = 16

local drawTilesetTilesToCanvas = function()
    love.graphics.setCanvas(tilesetCanvas)
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            for i=1, w do
                for j=1, h do
                    local offsetx, offsety = (x-1)*w, (y-1)*h
                    local p = sprites.getData(offsetx + i, offsety + j)
                    if p then
                        setColor(p and palette[p] or palette[1])
                        love.graphics.rectangle("fill", x*w+ox+i, y*h+oy+j, 1, 1)
                    end
                end
            end
        end
    end
    love.graphics.setCanvas()
end

local drawTilesetTiles = function()
    setColor(255,255,255)
    love.graphics.draw(tilesetCanvas)
end

local drawTilesetMarker = function()
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    love.graphics.setLineWidth(2)
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            if selectedTile.x == x and selectedTile.y == y then
                setColor(255,255,255)
                love.graphics.rectangle("line", ox+x*w, oy+y*h, w+2, h+2)
                break
            end
        end
    end
    love.graphics.setLineWidth(1)
end

local clickTileset = function(mx,my,btn)
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            if mx > ox+x*w and mx < ox+x*w+w and my > oy+y*h and my < oy+y*h+h then
                selectedTile = {
                    x = x,
                    y = y
                }
            end
        end
    end
end

local drawTileset = function()
    drawTilesetTiles()
    drawTilesetMarker()
end

--[[
    Public
]]--
tilesetPicker.update = function()
    drawTilesetTilesToCanvas()
end

tilesetPicker.init = function(c)
    console = c
    selectedTile = {x = 1, y = 1}
end

tilesetPicker.getTileWidth = function()
    return w
end

tilesetPicker.getTileHeight = function()
    return h
end

tilesetPicker.getOffsets = function()
    return (selectedTile.x - 1) * w, (selectedTile.y - 1) * h
end

tilesetPicker.draw = function()
    drawTileset()
end

tilesetPicker.click = function()
    clickTileset(love.mouse.getX(), love.mouse.getY(), 1)
end

tilesetPicker.getSelectedTileID = function()
    return selectedTile.x + (selectedTile.y - 1) * tilesetWidth
end

return tilesetPicker