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
    File: addPixelTool.lua
    Description: add a single pixel
]]--

--[[
    Utilities
]]--
local setColor = require("funcs.setColor")
local mouseOver = require("funcs.mouseOver")

--[[
    Components
]]--
local sprites = require("console.sprites")

--[[
    Private
]]--

--[[
    Public
]]--
local tool = {}

-- click on the canvas
tool.click = function(x,y,color)
    sprites.setData(x,y,color)
end

return tool