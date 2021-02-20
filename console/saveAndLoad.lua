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
    File: saveAndLoad.lua
    Description: saving and loading the cart
]]--

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
    --loadPixelEditor()
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