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
    File: mapEditor.lua
    Description: edit of the map
]]--

--[[
    Utilities
]]--
local setColor = require("funcs.setColor")

--[[
    Components
]]--
local topbar        = require("console.topbar")
local sprites       = require("console.sprites")
local map           = require("console.map")
local tilesetPicker = require("console.tilesetPicker")
local saveAndLoad   = require("console.saveAndLoad")
local saveText      = require("console.saveText")
local Camera        = require("lib.hump.camera")
local palette       = require("console.palette")

--[[
    Private
]]--
local console
local objects
local dragging
local camera
local pressedOnGui 

local addTile = function()
    local x,y = camera:mousePosition()
    if topbar.mousepressed(x,y,btn) then
    elseif tilesetPicker.click(x,y,btn) then
    else
        local tx, ty = math.floor(x/16), math.floor(y/16)
        map.setData(tx, ty, tilesetPicker.getSelectedTileID())
    end
end

local drag = function()
    local x,y = love.mouse.getX(), love.mouse.getY()
    if not dragging then
        dragging = {
            x = x, y = y
        }
    else
        local tx = x - dragging.x
        local ty = y - dragging.y
        dragging = {
            x = x, y = y
        }
        camera:move(-tx, -ty)
        camera.x = math.floor(camera.x)
        camera.y = math.floor(camera.y)
    end
end

local mapMouseHandle = function()
    if love.mouse.isDown(1) then
        if love.keyboard.isDown('space') or dragging then
            drag()
        else
            addTile()
        end
    else
        dragging = false
    end
end

local guiMouseHandle = function()
    local x,y = love.mouse.getX(), love.mouse.getY()
    if love.mouse.isDown(1) and not pressedOnGui and tilesetPicker.mousepressed(x,y,1) then
        pressedOnGui = true
        return true
    end
    if not love.mouse.isDown(1) then
        pressedOnGui = false
    end
    if pressedOnGui then return true end
end

local handleMouse = function()
    if not guiMouseHandle() then
        mapMouseHandle()
    end
end

--[[
    Public
]]--
local mapEditor = {}

mapEditor.update = function(dt)
    handleMouse()
end

mapEditor.draw = function()
    love.graphics.clear()
    setColor(0,0,0)
    love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), love.graphics.getHeight())
    camera:attach()
    for i=-32, 32 do
        for j=-32,32 do
            local t = map.getData(i, j)
            if t then
                setColor(255,255,255)
                love.graphics.draw(sprites.get(t), i*16, j*16)
            else
                setColor(palette[1])
                love.graphics.rectangle("fill", i*16, j*16, 16, 16)
            end
        end
    end
    camera:detach()
    setColor(255,255,255)
    topbar.draw()
    for item in all(objects) do
        item:draw()
    end
    tilesetPicker.draw()
end

mapEditor.keypressed = function(key)
    if key == "r" then
        console.game.init(console)
        console.game.runCode()
        console.switch(console.game)
    end
    if key == "s" then
        saveAndLoad.save()
        saveText.add(objects, "SAVED AS "..saveAndLoad.getCartFileName())
    end
    if key == "tab" then
        tilesetPicker.toggle()
        topbar.toggle()
    end
end

mapEditor.mousepressed = function(x,y,btn)
    
end

mapEditor.init = function(c)
    console = c
    camera = Camera(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
    objects = {}
    topbar.init(c)
    tilesetPicker.init()
end

return mapEditor