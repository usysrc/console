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
    File: toolbar.lua
    Description: utility bar
]]--

--[[
    Utilities
]]--
local t = require "funcs.table"
local all, del, add = t.all, t.del, t.add
local mouseOver = require("funcs.mouseOver")
local buttonClick = require("funcs.buttonClick")

--[[
    Components
]]--
local palette           = require("console.palette")
local setColor          = require "funcs.setColor"
local toolController    = require("console.tools.toolController")

--[[
    Private
]]--
local console
local buttons = {}
local toolbar = {}

local buttonFactory = {
    function()
        local btn = {}
        btn.x = 130
        btn.y = 150
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
            toolController.setTool(toolController.tools.pixelTool)
        end
        buttons[#buttons+1] = btn
    end,
    function()
        local btn = {}
        btn.x = 148
        btn.y = 150
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
            love.graphics.print("f", btn.x+3, btn.y-3)
            setColor(255,255,255)
        end
        btn.click = buttonClick
        btn.onClick = function()
            toolController.setTool(toolController.tools.fillTool)
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

toolbar.draw = function()
    if hidden then return end
    setColor(255,255,255)
    for button in all(buttons) do
        button.draw()
    end
end

toolbar.mousepressed = function(x,y,btn)
    if hidden then return end
    for button in all(buttons) do
        if button:click(x,y) then return true end
    end
end

toolbar.init = function(c)
    createButtons()
    console = c
end

toolbar.toggle = function()
    hidden = not hidden
end

return toolbar