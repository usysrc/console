local setColor = require "funcs.setColor"
local t = require "funcs.table"
local all, del, add = t.all, t.del, t.add

local game = {}

game.code = [[
    _draw = function()
        spr()
    end
    -- here be code:
]]

local env = {
    _init = function() end,
    _draw = function() end,
    _update = function() end,
    print = print,
    spr = function(x, y)
        local t = game.console.pixelEditor.getTileset()["1,1"]
        local pal = game.console.pixelEditor.getPalette()
        for i=1, 16 do
            for j=1,16 do
                setColor(pal[t[i..","..j]])
                love.graphics.rectangle("fill", i, j, 1, 1)
            end
        end
        setColor(255,255,255)
    end,
    all = all,
    del = del,
    add = add,
    btn = function(i)
        return love.keypressed(i)
    end
}

game.runCode = function()
    local g = loadstring(game.code)
    setfenv(g, env)
    g()
    env._init()
end

game.update = function(dt)
    env._update(dt)
end

game.draw = function()
    love.graphics.clear()
    env._draw()
end

game.keypressed = function(key)
    if key == "escape" then
        game.console.switch(game.console.cmdline)
    end
end
game.mousepressed = function(...)
end

game.init = function(console)
    game.console = console
end

return game