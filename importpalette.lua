#!/usr/bin/env lua
--[[

    Copyright 2021 USYSRC

    This is used to import palettes from list of hex values and 
    save them to the palettes folder with the given file name.

    Example input
    
        #040303
        #1c1618
        #47416b
        #6c8c50
        #e3d245
        #d88038
        #a13d3b
        #4e282e
        #9a407e
        #f0d472
        #f9f5ef
        #8a8fc4

]]--

--[[
    CONFIGURATION
]]-- 
local folder = "palettes/"

--[[
    UTILITIES
--]]

function trim(s)
    return s:match "^%s*(.-)%s*$"
end

function removeHash(str)
    if str:sub(1,1) == "#" then 
        return str:sub(2,-1)
    else 
        return str 
    end
end

--[[
    PROGRAM
]]--

--
-- READ INPUT
--
io.write("file name: ")
local filename = io.read()

print("list of hex values, empty line to start processing:")
local input = {}
for line in io.lines() do
    if line == "" then
        break
    else
        input[#input + 1] = removeHash(trim(line))
    end
end

--
-- CONVERT INPUT
--
local str = ""
local pr = function(a)
    str = str .. a .. "\n"
end

pr("return {")
for _, hex in ipairs(input) do
    local r = hex:sub(1,2)
    local g = hex:sub(3,4)
    local b = hex:sub(5,6)
    if #r < 1 or #g < 1 or #b < 1 then
        print("wrong color format, should be like #115599")
        return
    end
    pr("\t{".. tonumber("0x"..r)..","..tonumber("0x"..g)..","..tonumber("0x"..b).. "},")
end
pr("}")

print(str)

--
-- WRITE TO FILE
--
if not filename then
    return
end
file = io.open(folder .. filename, "w")
io.output(file)
io.write(str)
io.close(file)

print("written to "..folder..filename)