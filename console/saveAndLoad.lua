--[[
    Utilities
]]--
local serialize     = require("lib.ser")

--[[
    Components
]]--
local sprites       = require("console.sprites")
local map           = require("console.map")

--[[
    Private
]]--
local console
local cartFileName = "game.cart"
local cartsFolder = "carts/"
local delim = "=============================================="

local loadPixelEditor = function()
    if not love.filesystem.getInfo(cartsFolder..cartFileName) then
        return
    end

    local target = "code"
    local output = {
        code = "",
        data = ""
    }
    
    for line in love.filesystem.lines(cartsFolder..cartFileName) do
        if string.find(line, delim) then
            target = "data"
        else
            output[target] = output[target] .. line .. "\n"
        end
    end
    local data = assert(loadstring(output.data))()
    sprites.setAllData(data.sprites)
    map.setAllData(data.map)
    console.game.code = output.code
end

love.focus = function()
    loadPixelEditor()
end

local saveGame = function()
    local data = {}
    data.sprites = sprites.getAllData()
    data.map = map.getAllData()
    local output = ""
    output = output .. console.game.code
    output = output .. delim.."\n"
    output = output .. serialize(data)
    love.filesystem.write(cartsFolder..cartFileName, output)
end

--[[
    Public
]]--
local saveAndLoad = {}

saveAndLoad.save = saveGame

saveAndLoad.load = loadPixelEditor

saveAndLoad.init = function(c)
    console = c
end

saveAndLoad.getCartFileName = function()
    return cartFileName
end

return saveAndLoad