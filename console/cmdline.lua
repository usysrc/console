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
    File: cmdline.lua
    Description: a weird tiny little shell
]]--

--[[
    Utilities
]]--
local bitser = require 'lib.bitser'

--[[
    Private
]]--
local cmdline = {}
local input = ""
local hbuffer = ""
local linestart = "> "
local history = {}

-- generate a savedir and placeholder file
love.filesystem.setIdentity("console")
local file = love.filesystem.newFile("carts/readme")
file:open("w")
file:write("placeholder")
file:close()

local file = love.filesystem.newFile("settings")
file:open("w")
file:write("placeholder")
file:close()

local help = [[
            help:
                ls to list files

        ]]


local execute = function(input)
    if input == "help" then
        hbuffer = hbuffer .. help .. "\n"
    elseif input:sub(1,4) == "save" then
        local what = input:sub(6,-1)
        if not what or what == "" then
            hbuffer = hbuffer .. "please give cart name" .. "\n"
        else
            local what = what
            if not string.find(input, ".cart") then
                what = what .. ".cart" 
            end
            cmdline.console.pixelEditor.save(what)
        end
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
            local what = what
            if not string.find(input, ".cart") then
                what = what .. ".cart" 
            end
            files = love.filesystem.getDirectoryItems( "carts" ) 
            local f
            for i,v in pairs(files) do
                if v == what then
                    f = v
                end
            end
            if not f then
                hbuffer = hbuffer .. what .. " not found!" .. "\n"
            else
                draw.load(what)
                hbuffer = hbuffer .. "loaded " .. what .. "\n"    
            end
        else
            hbuffer = hbuffer .. "load what?" .. "\n"
        end
    elseif input:sub(1,2) == "rm" then
        local what = input:sub(4,-1)
        if what and what ~= "" then
            local what = what
            if not string.find(input, ".cart") then
                what = what .. ".cart" 
            end
            files = love.filesystem.getDirectoryItems( "carts" ) 
            local f
            for i,v in pairs(files) do
                if v == what then
                    f = v
                end
            end
            if not f then
                hbuffer = hbuffer .. what .. " not found!" .. "\n"
            else
                love.filesystem.remove("carts/"..what)
                hbuffer = hbuffer .. "removed " .. what .. "\n"
            end
        else
            hbuffer = hbuffer .. "delete what?" .. "\n"
        end
    elseif input == "run" or input == "start" then
        cmdline.console.game.runCode()
        cmdline.console.switch(cmdline.console.game)
    elseif input == "exit" or input == "quit" then
        love.event.push('quit')
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
        cmdline.console.switch(cmdline.console.pixelEditor)
    elseif #key > 1 then
        -- catch any mod keys
    else
        input = input .. key
        x = x + 1
    end
end

cmdline.mousepressed = function(...)
end

cmdline.init = function(console)
    cmdline.console = console
end

return cmdline