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
    File: pixelEditor.lua
    Description: edit the sprites
]]--

--[[
    Utilities
]]--
local setColor      = require("funcs.setColor")
local t             = require("funcs.table")
local all, del, add = t.all, t.del, t.add

--[[
    Components
]]--
local topbar        = require("console.topbar")
local sprites       = require("console.sprites")
local palette       = require("console.palette")
local tilesetPicker = require("console.tilesetPicker")
local saveAndLoad   = require("console.saveAndLoad")
local saveText      = require("console.saveText")

--[[
    Private
]]--
local draw = {}

local objects = {}
local console
local selectedBlock
local status = ""
local blocks = {}
local ox, oy = 80, 12
local tw, th = 8,8
local clipboard

--[[
    Color palette 
]]--
local initBlocks = function()
    local ox, oy = 8, 50
    blocks = {}
    for i,v in ipairs(palette) do
        local k = i - 1
        local block = {}
        block.x = ox + (k%4)*16
        block.y = oy + math.floor(k/4)*16
        block.w = 16
        block.h = 16
        block.color = i
        block.draw = function()
            setColor(palette[block.color])
            love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
        end
        block.drawOverlay = function()
            if block.selected then
                local w = love.graphics.getLineWidth()
                love.graphics.setLineWidth(2)
                setColor(255, 255, 255)
                love.graphics.rectangle("line", block.x-1, block.y-1, block.w+2, block.h+2)
                love.graphics.setLineWidth(w)
            end
        end
        blocks[#blocks+1] = block
    end
end

local findColorInBlocks = function(color)
    for _, block in ipairs(blocks) do
        if block.color == color then
            return block
        end
    end
end

local drawBlocks = function()
    for _,block in ipairs(blocks) do
        block.draw()
    end
    for _,block in ipairs(blocks) do
        block.drawOverlay()
    end
    setColor(255,255,255)
end

--[[
    Move Command
]]--
local move = function(tx, ty)
    local offsetx, offsety = tilesetPicker.getOffsets()
    local newCanvas = {}
    local w, h = tilesetPicker.getTileWidth(), tilesetPicker.getTileHeight()
    for i=1, w do
        for j=1, h do
            local col = sprites.getData(offsetx + i,offsety + j)
            local ti, tj = i + tx, j + ty
            if ti < 1 then ti = w end
            if ti > w then ti = 1 end
            if tj < 1 then tj = h end
            if tj > h then tj = 1 end
            newCanvas[ti..","..tj] = col
        end
    end
    for i=1, w do
        for j=1, h do
            sprites.setData(offsetx + i, offsety + j, newCanvas[i..","..j])
        end
    end
    
    tilesetPicker.update()
end

local moveLeft = function()
    move(-1, 0)
end
local moveRight = function()
    move(1, 0)
end
local moveUp = function()
    move(0, -1)
end
local moveDown = function()
    move(0, 1)
end

local foralltiles = function(fn)
    for i=1, tilesetPicker.getTileWidth() do
        for j=1, tilesetPicker.getTileHeight() do
            fn(i,j)
        end
    end
end

--[[
    Pixel canvas
]]--
local drawCanvas = function()
    local offsetx, offsety = tilesetPicker.getOffsets()
    foralltiles(function(i,j)
        local p = sprites.getData(offsetx + i, offsety + j)
        setColor(p and palette[p] or palette[1])
        love.graphics.rectangle("fill", ox+i*tw, oy+j*th, tw, th)
    end)
end

local initCanvas = function()
    if sprites.getData(1,1) then return end
    for i=1, tilesetPicker.getTileWidth() do
        for j=1, tilesetPicker.getTileHeight() do
            sprites.setData(i, j, 1)
        end
    end
end

local leftClickCanvas = function(x,y)
    local offsetx, offsety = tilesetPicker.getOffsets()
    foralltiles(function(i,j)
        if x > ox + i * tw and x <= ox+i*tw + tw and y > oy + j * th and y <= oy+j*th + th then
            if selectedBlock then
                sprites.setData(offsetx + i, offsety + j,selectedBlock.color)
                tilesetPicker.update()
                return
            end
        end
    end)
end

local rightClickCanvas = function(x,y)
    local offsetx, offsety = tilesetPicker.getOffsets()
    foralltiles(function(i,j)
        if x > ox + i * tw and x <= ox+i*tw + tw and y > oy + j * th and y <= oy+j*th + th then
            local data = sprites.getData(offsetx + i, offsety + j)
            if data then
                local blk = findColorInBlocks(data)
                if blk then
                    if selectedBlock then selectedBlock.selected = false end
                    selectedBlock = blk
                    selectedBlock.selected = true
                end
            end
        end
    end)
end

local clickCanvas = function(x, y, btn)
    if btn == 1 then
        leftClickCanvas(x, y)
    elseif btn == 2 then
        rightClickCanvas(x, y)
    end
end

draw.update = function(dt)
    if love.mouse.isDown(1) then
        clickCanvas(love.mouse.getX(), love.mouse.getY(), 1)
        tilesetPicker.click(love.mouse.getX(), love.mouse.getY(), 1)
    elseif love.mouse.isDown(2) then
        clickCanvas(love.mouse.getX(), love.mouse.getY(), 2)
    end
    topbar.draw()
end

draw.draw = function()
    love.graphics.clear()
    setColor(palette[2])
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    setColor(255,255,255)
    drawBlocks()
    setColor(255,255,255)
    drawCanvas()
    setColor(255,255,255)
    tilesetPicker.draw()
    setColor(255,255,255)
    for item in all(objects) do
        item:draw()
    end
    topbar.draw()
end

local copyToClipboard = function()
    local offsetx, offsety = tilesetPicker.getOffsets()
    clipboard = {}
    foralltiles(function(i,j)
        clipboard[i..","..j] = sprites.getData(offsetx + i, offsety + j)
    end)
end

local cut = function()
    copyToClipboard()
    local offsetx, offsety = tilesetPicker.getOffsets()
    foralltiles(function(i,j)
        sprites.setData(offsetx + i, offsety + j, 1)
    end)
    tilesetPicker.update()
end

local paste = function()
    if not clipboard then return end
    local offsetx, offsety = tilesetPicker.getOffsets()
    foralltiles(function(i,j)
        sprites.setData(offsetx + i, offsety + j, clipboard[i..","..j])
    end)
    tilesetPicker.update()
end

--[[
    Public
]]--
draw.keypressed = function(key)
    if key == "escape" then
        console.switch(console.cmdline)
    end
    if key == "left" then
        moveLeft()
    end
    if key == "right" then
        moveRight()
    end
    if key == "up" then
        moveUp()
    end
    if key == "down" then
        moveDown()
    end
    if key == "s" then
        saveAndLoad.save()
        saveText.add(objects)
    end
    if key == "r" then
        console.game.init(console)
        console.game.runCode()
        console.switch(console.game)
    end
    if key == "c" then
        copyToClipboard()
    end
    if key == "v" then
        paste()
    end
    if key == "x" then
        cut()
    end
    if key == "tab" then
        tilesetPicker.toggle()
        topbar.toggle()
    end
end

draw.mousepressed = function(x, y, btn)
    for _, block in ipairs(blocks) do
        if x > block.x and x < block.x + block.w and y > block.y and y < block.y + block.h then
            if selectedBlock then
                selectedBlock.selected = false
            end
            block.selected = true
            selectedBlock = block
            break
        end
    end
    topbar.mousepressed(x,y,btn)
end

draw.init = function(c)
    console = c
    tilesetPicker.init(c)
    topbar.init(c)
    initBlocks()
    initCanvas()
    saveAndLoad.init(c)
    saveAndLoad.load()
    tilesetPicker.update()
    selectedBlock = blocks[#blocks]
    selectedBlock.selected = true
end

draw.getTileset = function()
    return tileset
end

draw.getPalette = function()
    return palette
end

return draw