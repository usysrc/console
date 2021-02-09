local console = {}

--
-- startup
--


--
-- set up different tabs
--

console.cmdline = require "console.cmdline"

console.pixelEditor = require "console.pixelEditor"

console.mapEditor = require("console.mapEditor")

console.game = require("console.game")


console.game.init(console)
console.pixelEditor.init(console)
console.mapEditor.init(console)
console.cmdline.init(console)

local tab = console.pixelEditor

console.switch = function(targetTab)
    assert(targetTab)
    assert(type(targetTab) == "table")
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