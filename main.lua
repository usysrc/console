local display = require "display.display"
local console = require "console.console"

function love.update(dt)
    display.update(dt)
    console.update(dt)
end

function love.draw()
    display.beginDraw()
    console.draw()
    display.endDraw()
end

function love.keypressed(key)
    display.keypressed(key)
    console.keypressed(key)
end

function love.mousepressed(...)
    display.mousepressed(console.mousepressed, ...)
end