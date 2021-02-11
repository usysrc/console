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
    File: display.lua
    Description: wrapper for the output
]]--

local display = {}
local scale = 2
local minScale = 1
local w = 250
local h = 250

success = love.window.updateMode( w * scale, h * scale, settings )

local canvas = love.graphics.newCanvas(w, h)
canvas:setFilter('nearest', 'nearest')
love.graphics.setFont(love.graphics.newFont("fonts/monogram.ttf", 16))
love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(1)

display.update = function(dt)
    if dt < 1/30 then
        love.timer.sleep(1/30 - dt)
    end
end

display.beginDraw = function()
    
    love.graphics.setCanvas(canvas)
end

display.endDraw = function()
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, scale, scale)
end

display.keypressed = function(key)
    if key == '=' then
        scale = scale + 1
        success = love.window.updateMode( w * scale, h * scale, settings )
    end
    if key == '-' then
        scale = math.max(minScale, scale - 1)
        success = love.window.updateMode( w * scale, h * scale, settings )
    end
end

local lmx, lmy = love.mouse.getX, love.mouse.getY
love.mouse.getX = function()
    return lmx()/scale
end
love.mouse.getY = function()
    return lmy()/scale
end

display.mousepressed = function(fn, x, y, btn)
    local x = x / scale
    local y = y / scale
    fn(x,y,btn)
end

return display