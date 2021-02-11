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
    File: game.lua
    Description: this is where the game is played
]]--

--[[
    Utilities
]]--
local setColor = require("funcs.setColor")
local t = require("funcs.table")
local all, del, add = t.all, t.del, t.add

--[[
    Components
]]--
local palette = require("console.palette")
local sprites   = require("console.sprites")
local map       = require("console.map")

--[[
    Private
]]--
local console

local game = {}

game.code = [[
_draw = function()
    map()
end
-- here be code:
]]

local down = {}

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
    cls = function()
        love.graphics.clear()
    end,
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
    end,
    map = function(cell_x, cell_y, sx, sy,cell_w,cell_h)
        for i=cell_x or 1, cell_w or 128 do
            for j=cell_y or 1, cell_h or 128 do
                local ti = map.getData(i,j)
                if ti then
                    setColor(255,255,255)
                    love.graphics.draw(sprites.get(ti), i*16, j*16)
                end
            end
        end
        setColor(255,255,255)
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