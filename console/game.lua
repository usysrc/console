local game = {}

game.code = [[
    -- here be code:
]]

local sandbox = {}
game.runCode = function(fn)
    setfenv(fn, setfenv)

end


game.update = function(dt)

end

game.draw = function()
    love.graphics.clear()
end

game.keypressed = function(key)
    if key == "escape" then
        game.console.switch(game.console.cmdline)
    end
end
game.mousepressed = function(...)
end

game.init = function()
    
end

return game