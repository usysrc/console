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
    File: fillTool.lua
    Description: flood fill a region
]]--

--[[
    Components
]]--
local sprites = require("console.sprites")

--[[
    Public
]]--
local tool = {}

-- click on the canvas
-- the actual floodfill
tool.click = function(x,y,color)
    local oldColor = sprites.getData(x,y)
    if color == oldColor then return end
    local colorize
    colorize = function(x, y)
        local col = sprites.getData(x, y)
        if col and col == oldColor then
            sprites.setData(x,y,color)
        else
            return
        end
        colorize(x + 1, y)
        colorize(x - 1, y)
        colorize(x, y + 1)
        colorize(x, y - 1)
    end
    colorize(x, y)
end

return tool