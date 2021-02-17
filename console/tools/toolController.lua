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
    File: toolbarController.lua
    Description: this holds the tools
]]--

local pixelTool = require("console.tools.addPixelTool")
local fillTool  = require("console.tools.fillTool")

local tools = {
    pixelTool = pixelTool,
    fillTool = fillTool
}

local tool = fillTool

return {
    tools = tools,
    setTool = function(newTool)
        print(newTool)
        tool = newTool
    end,
    click = function(x,y,col)
        if tool and tool.click then
            tool.click(x,y,col)
        end
    end
}