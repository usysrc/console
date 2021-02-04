local draw = require("console.draw")

local cmdline = {}

local input = ""
local hbuffer = ""
local linestart = "> "

local history = {}


-- generate a savedir and placeholder file
love.filesystem.setIdentity( "console" )
file = love.filesystem.newFile("carts/readme")
file:open("w")
file:write("placeholder")
file:close()

local help = [[
            help:
                ls to list files

        ]]

local load = function(filename)
    
end

local execute = function(input)
    if input == "help" then
        hbuffer = hbuffer .. help .. "\n"
    elseif input == "ls" then
        files = love.filesystem.getDirectoryItems( "carts" ) 
        for i,v in pairs(files) do
            hbuffer = hbuffer .. v .. "\n"
        end
    elseif input == "folder" then
        love.system.openURL("file://"..love.filesystem.getSaveDirectory())
    elseif input == "clear" or input == "cls" then
        hbuffer = ""
    elseif input:sub(1,4) == "load" then
        local what = input:sub(6,-1)
        if what and what ~= "" then
            files = love.filesystem.getDirectoryItems( "carts" ) 
            local f
            for i,v in pairs(files) do
                if v == what then
                    f = v
                end
            end
            if not f then
                hbuffer = hbuffer .. what .. " not found!" .. "\n"
            end
        else
            hbuffer = hbuffer .. "load what?" .. "\n"
        end
    else
        hbuffer = hbuffer .. "unknown command" .. "\n"
    end
end
local b = 0
local cursor
local x, y = 0, 0
x = #linestart

cmdline.draw = function()
    love.graphics.clear()
    love.graphics.print(hbuffer .. linestart .. input)
    if cursor then
        love.graphics.rectangle("fill", x * 6, y*13, 8, 16)
    end
end

cmdline.update = function(dt) 
    b = b + 0.15
    if math.sin(b) >= 0 then
        cursor = false
    else
        cursor = true
    end
end

cmdline.keypressed = function(key)
    print(key)
    if key == "return" then
        history[#history+1] = input
        hbuffer = hbuffer .. linestart .. input.."\n"
        execute(input)
        input = ""
        x = #linestart
        local _, count = hbuffer:gsub('\n', '\n')
        if count > 16 then
            count = 0
            hbuffer = ""
        end
        y = count
    elseif key == "backspace" then
        if #input > 1 then
            input = input:sub(1,#input-1)
            x = x - 1
        elseif #input == 1 then
            input = ""
            x = x - 1
        end
    elseif key == "up" then
        if #history > 0 then
            input = history[#history]
            x = #linestart + #input
        end
    elseif key == "space" then
        input = input .." "
        x = x + 1
    elseif key == "l" and love.keyboard.isDown("lctrl") then
        execute("clear")
        y = 0
    elseif key == "left" then
        x = x - 1
    elseif key == "right" then
        x = x + 1
        if x > #linestart + #input then
            x = #linestart + #input
        end
    elseif key == "escape" then
        cmdline.console.switch(draw)
    elseif #key > 1 then
        -- catch any mod keys
    else
        input = input .. key
        x = x + 1
    end
end
cmdline.mousepressed = function(...)
end

return cmdline