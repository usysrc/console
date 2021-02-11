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

--[[
    Private
]]--
local console


--[[
    Public
]]--
local mapEditor = {}

mapEditor.update = function(dt)

end

mapEditor.draw = function()
    love.graphics.clear()
    for i=1, 16 do
        for j=1,16 do
            local t = map.getData(i, j)
            if t then
                love.graphics.draw(sprites.get(t), i*16, j*16)
            end
        end
    end
    setColor(255,255,255)
    topbar.draw()
    tilesetPicker.draw()
end

mapEditor.keypressed = function(key)
    if key == "r" then
        console.game.init(console)
        console.game.runCode()
        console.switch(console.game)
    end
end

mapEditor.mousepressed = function(x,y,btn)
    local tx, ty = math.floor(x/16), math.floor(y/16)
    if ty > 1 and ty < 11 then
        map.setData(tx, ty, tilesetPicker.getSelectedTileID())
    end
    topbar.mousepressed(x,y,btn)
    tilesetPicker.click(x,y,btn)
end

mapEditor.init = function(c)
    console = c
    topbar.init(c)
    tilesetPicker.init()
end

return mapEditor