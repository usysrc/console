local game = {}

game.code = [[
    print("hi")
    _draw = function()
        print("hi")
    end
    -- here be code:
]]

local env = {
    _init = function() end,
    _draw = function() end,
    _update = function() end,
    print = print,
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