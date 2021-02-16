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
    File: topbar.lua
    Description: utility bar
]]--

--[[
    Utilities
]]--
local t = require "funcs.table"
local all, del, add = t.all, t.del, t.add

--[[
    Components
]]--
local palette = require("console.palette")
local setColor = require "funcs.setColor"

--[[
    Private
]]--
local console
local buttons = {}

local topbar = {}

local mouseOver = function(btn, x, y)
    return x > btn.x and x < btn.x + btn.w and y > btn.y and y < btn.y + btn.h
end

local buttonClick = function(btn, x, y)
    if mouseOver(btn, x, y) then
        if btn.onClick then btn.onClick(); return true end
    end
end

local buttonFactory = {
    function()
        local btn = {}
        btn.x = 8
        btn.y = 2
        btn.w = 12
        btn.h = 12
        btn.draw = function()
            setColor(palette[3])
            love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h)
            if mouseOver(btn, love.mouse.getX(), love.mouse.getY()) then
                setColor(255,255,255)
            else
                setColor(128,128,128) 
            end
            love.graphics.print("m", btn.x+3, btn.y-3)
            setColor(255,255,255)
        end
        btn.click = buttonClick
        btn.onClick = function()
            console.switch(console.mapEditor)
        end
        buttons[#buttons+1] = btn
    end,
    function()
        local btn = {}
        btn.x = 24
        btn.y = 2
        btn.w = 12
        btn.h = 12
        btn.draw = function()
            setColor(palette[3])
            love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h)
            if mouseOver(btn, love.mouse.getX(), love.mouse.getY()) then
                setColor(255,255,255)
            else
                setColor(128,128,128) 
            end
            love.graphics.print("p", btn.x+3, btn.y-3)
            setColor(255,255,255)
        end
        btn.click = buttonClick
        btn.onClick = function()
            console.switch(console.pixelEditor)
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

topbar.draw = function()
    if hidden then return end
    setColor(palette[2])
    love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), 16)
    setColor(255,255,255)
    for button in all(buttons) do
        button.draw()
    end
end

topbar.mousepressed = function(x,y,btn)
    if hidden then return end
    for button in all(buttons) do
        if button:click(x,y) then return true end
    end
end

topbar.init = function(c)
    createButtons()
    console = c
end

topbar.toggle = function()
    hidden = not hidden
end

return topbar