local setColor = require "funcs.setColor"
local topbar = require "console.topbar"

local mapEditor = {}
local map = {}
local selectedTile

local console

mapEditor.update = function(dt)

end

mapEditor.draw = function()
    love.graphics.clear()
    for i=1, 16 do
        for j=1,16 do
            local t = map[i..","..j]
            if t then
                
            end
        end
    end
    setColor(255,255,255)
    topbar.draw()
end

mapEditor.keypressed = function(key)
    
end

mapEditor.mousepressed = function(x,y,btn)
    local tx, ty = math.floor(x/16), math.floor(y/16)
    map[tx..","..ty] = selectedTile
    topbar.mousepressed(x,y,btn)
end

mapEditor.init = function(c)
    console = c
    topbar.init(c)
end



return mapEditor
