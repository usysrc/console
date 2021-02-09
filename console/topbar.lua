local t = require "funcs.table"
local all, del, add = t.all, t.del, t.add


local palette = require("console.palette")
local setColor = require "funcs.setColor"

local console

local topbar = {}

local buttons = {}

local buttonClick = function(btn, x, y)
    if x > btn.x and x < btn.x + btn.w and y > btn.y and y < btn.y + btn.h then
        if btn then btn.onClick() end
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
            setColor(255,255,255)
            love.graphics.print("m", btn.x+3, btn.y-3)
        end
        btn.click = buttonClick
        btn.onClick = function()
            console.switch(console.mapEditor)
        end
        buttons[#buttons+1] = btn
    end,
}

local createButtons = function()
    for btnFactory in all(buttonFactory) do
        btnFactory()
    end
end

createButtons()

topbar.draw = function()
    setColor(palette[2])
    love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), 16)
    setColor(255,255,255)
    for button in all(buttons) do
        button.draw()
    end
end

topbar.mousepressed = function(x,y,btn)
    for button in all(buttons) do
        button:click(x,y)
    end
end

topbar.init = function(c)
    console = c
end

return topbar