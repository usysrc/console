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
    File: console.lua
    Description: the main entry point for the console
]]--

local console = {}

--
-- startup
--


--
-- set up different tabs
--

console.cmdline = require "console.cmdline"

console.pixelEditor = require "console.pixelEditor"

console.mapEditor = require("console.mapEditor")

console.game = require("console.game")


console.game.init(console)
console.pixelEditor.init(console)
console.mapEditor.init(console)
console.cmdline.init(console)

local tab = console.pixelEditor

console.switch = function(targetTab)
    assert(targetTab)
    assert(type(targetTab) == "table")
    tab = targetTab
end

console.update = function(dt) 
    tab.update(dt)
end

console.draw = function()
    tab.draw()
end

console.keypressed = function(key)
    tab.keypressed(key)
    
    
end

console.mousepressed = function(...)
    tab.mousepressed(...)
end



return console