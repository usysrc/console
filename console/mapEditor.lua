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