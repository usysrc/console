local palette = require("console.palette")
local setColor = require("funcs.setColor")
local t = require("funcs.table")
local all, del, add = t.all, t.del, t.add

local game = {}

game.code = [[
_draw = function()
    spr()
end
-- here be code:
]]

local down = {}

local sprites = require "console.sprites"

local console

local env = {
    _init = function() end,
    _draw = function() end,
    _update = function() end,
    print = print,
    spr = function(ti, x, y)
        local ti, x, y = ti or 1, x or 0, y or 0
        setColor(255,255,255)
        love.graphics.draw(sprites.get(ti), x, y)
        setColor(255,255,255)
    end,
    all = all,
    del = del,
    add = add,
    btn = function(i)
        return love.keyboard.isDown(i)
    end,
    btnp = function(i)
        local isDown = love.keyboard.isDown(i)
        if down[i] and isDown then
            return false
        end
        if down[i] and not isDown then
            down[i] = false
            return false
        elseif not down[i] and isDown then
            down[i] = true
            return true
        end
    end
}

game.runCode = function()
    game.err = ""
    local g, err = loadstring(game.code)
    if err then
        print(err)
        game.err = err
        return
    end
    setfenv(g, env)
    local status, err = pcall(g)
    if err then
        game.err = err
        return
    end
    env._init()
end

game.update = function(dt)
    env._update(dt)
end

game.draw = function()
    love.graphics.clear()
    setColor(palette[1])
    love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), love.graphics.getHeight())
    
    env._draw()
    setColor(255,255,255)
    if game.err then love.graphics.print(game.err) end
end

game.keypressed = function(key)
    if key == "escape" then
        console.switch(console.pixelEditor)
    end
end
game.mousepressed = function(...)
end

game.init = function(c)
    console = c
    sprites.init()
end

return game