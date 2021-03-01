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
    File: pickerButtons.lua
    Description: change the part of the spritesheet seen in the picker
]]--

--[[
    Utilities
]]--
local t = require "funcs.table"
local all, del, add = t.all, t.del, t.add
local mouseOver = require("funcs.mouseOver")
local buttonClick = require("funcs.buttonClick")
local image = require("image.image")

--[[
    Components
]]--
local palette           = require("console.palette")
local setColor          = require "funcs.setColor"

--[[
    Public
]]--
    
local pickerButtons = {}

local hidden = false
local buttons = {}
local tilesetPicker

local buttonFactory = {
    function()
        local btn = {}
        btn.x = 280
        btn.y = 180
        btn.w = 16
        btn.h = 16
        btn.draw = function()
            setColor(palette[3])
            love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h)
            if mouseOver(btn, love.mouse.getX(), love.mouse.getY()) then
                setColor(255,255,255)
            else
                setColor(128,128,128)
            end
            love.graphics.draw(image("arrowright"), btn.x, btn.y)
            setColor(255,255,255)
        end
        btn.click = buttonClick
        btn.onClick = function()
            tilesetPicker.setOffset(tilesetPicker.getOffset() + 1)
        end
        buttons[#buttons+1] = btn
    end,
    function()
        local btn = {}
        btn.x = 280
        btn.y = 200
        btn.w = 16
        btn.h = 16
        btn.draw = function()
            setColor(palette[3])
            love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h)
            if mouseOver(btn, love.mouse.getX(), love.mouse.getY()) then
                setColor(255,255,255)
            else
                setColor(128,128,128) 
            end
            love.graphics.draw(image("arrowleft"), btn.x, btn.y)
            setColor(255,255,255)
        end
        btn.click = buttonClick
        btn.onClick = function()
            tilesetPicker.setOffset(tilesetPicker.getOffset() - 1)
        end
        buttons[#buttons+1] = btn
    end,
}

local createButtons = function()
    buttons = {}
    for btnFactory in all(buttonFactory) do
        btnFactory()
    end
end

pickerButtons.draw = function()
    if hidden then return end
    setColor(255,255,255)
    for button in all(buttons) do
        button.draw()
    end
end

pickerButtons.mousepressed = function(x,y,btn)
    if hidden then return end
    for button in all(buttons) do
        if button:click(x,y) then return true end
    end
end

pickerButtons.init = function(c, t)
    createButtons()
    console = c
    tilesetPicker = t
end

pickerButtons.toggle = function()
    hidden = not hidden
end

return pickerButtons