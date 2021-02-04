local console = {}

local cmdline = require "console.cmdline"
cmdline.console = console

local draw = require "console.draw"
draw.console = console

local tab = draw

console.switch = function(targetTab)
    tab = targetTab
end

console.update = function(dt) 
    tab.update(dt)
end

console.draw = function()
    tab.draw()
end

console.keypressed = function(key)
    tab.keypressed(key)
end
console.mousepressed = function(...)
    tab.mousepressed(...)
end

return console