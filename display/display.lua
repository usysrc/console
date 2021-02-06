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