local draw = {}
local setColor = function(a, b, c, d)
    if type(a) == 'table' then
        love.graphics.setColor(a[1]/255, a[2]/255, a[3]/255)
    elseif type(a) == 'number' and b and c then
        love.graphics.setColor(a/255, b/255, c/255, (d or 255)/255)
    end
end


local palette = require "palettes.pico8"
local selectedBlock
local blocks = {}
local ox, oy = 8, 50
for i,v in ipairs(palette) do
    local k = i - 1
    local block = {}
    block.x = ox + (k%4)*16
    block.y = oy + math.floor(k/4)*16
    block.w = 16
    block.h = 16
    block.color = i
    block.draw = function()
        setColor(palette[block.color])
        love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
    end
    block.drawOverlay = function()
        if block.selected then
            local w = love.graphics.getLineWidth()
            love.graphics.setLineWidth(2)
            setColor(255, 255, 255)
            love.graphics.rectangle("line", block.x-1, block.y-1, block.w+2, block.h+2)
            love.graphics.setLineWidth(w)
        end
    end
    blocks[#blocks+1] = block
end

local findColorInBlocks = function(color)
    for _, block in ipairs(blocks) do
        if block.color == color then
            return block
        end
    end
end

local drawBlocks = function()
    for _,block in ipairs(blocks) do
        block.draw()
    end
    for _,block in ipairs(blocks) do
        block.drawOverlay()
    end
    setColor(255,255,255)
end

local tileset = {}
local tilesetOffsetX, tilesetOffsetY = 4, 164
local tilesetWidth = 14
local tilesetHeight = 4
for i = 1, tilesetWidth do
    for j = 1,tilesetHeight do
        tileset[i..","..j] = {}
    end
end

local canvas = tileset["1,1"]

local w = 16
local h = 16
local ox, oy = 80, 12
local tw, th = 8,8

local tilesetCanvas = love.graphics.newCanvas()
local drawTilesetTilesToCanvas = function()
    love.graphics.setCanvas(tilesetCanvas)
    local currentCanvas = canvas
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            local canvas = tileset[x..","..y]
            for i=1, w do
                for j=1, h do
                    if canvas[i..","..j] then
                        setColor(canvas[i..","..j] and palette[canvas[i..","..j]] or palette[2])
                        love.graphics.rectangle("fill", x*w+ox+i, y*h+oy+j, 1, 1)
                    end
                end
            end
        end
    end
    love.graphics.setCanvas()
end

local drawTilesetTiles = function()
    setColor(255,255,255)
    love.graphics.draw(tilesetCanvas)
end

local drawTilesetMarker = function()
    local currentCanvas = canvas
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            if currentCanvas == tileset[x..","..y] then
                setColor(255,255,255)
                love.graphics.rectangle("line", ox+x*w-1, oy+y*h-1, w+5, h+5)
                break
            end
        end
    end
end

local drawTileset = function()
    drawTilesetTiles()
    drawTilesetMarker()
end

local initCanvas = function(canvas)
    if canvas["1,1"] then return end
    for i=1, w do
        for j=1, h do
            canvas[i..","..j] = 2
        end
    end
end
for x = 1, tilesetWidth do
    for y = 1, tilesetHeight do
        initCanvas(tileset[x..","..y])
    end
end
drawTilesetTilesToCanvas()

local clickTileset = function(mx,my,btn)
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            if mx > ox+x*w and mx < ox+x*w+w and my > oy+y*h and my < oy+y*h+h then
                canvas = tileset[x..","..y]
            end
        end
    end
end

local drawCanvas = function()
    for i=1, w do
        for j=1, h do
            setColor(canvas[i..","..j] and palette[canvas[i..","..j]] or palette[2])
            love.graphics.rectangle("fill", ox+i*tw, oy+j*th, tw, th)
        end
    end
end

local leftClickCanvas = function(x,y)
    for i=1, w do
        for j=1,h do
            if x > ox + i * tw and x <= ox+i*tw + tw and y > oy + j * th and y <= oy+j*th + th then
                if selectedBlock then
                    canvas[i..","..j] = selectedBlock.color
                    drawTilesetTilesToCanvas()
                    break
                end
            end
        end
    end
end

local rightClickCanvas = function(x,y)
    for i=1, w do
        for j=1,h do
            if x > ox + i * tw and x <= ox+i*tw + tw and y > oy + j * th and y <= oy+j*th + th then
                print("clickcckc")
                if canvas[i..","..j] then
                    local blk = findColorInBlocks(canvas[i..","..j])
                    if blk then
                        if selectedBlock then selectedBlock.selected = false end
                        selectedBlock = blk
                        selectedBlock.selected = true
                    end
                end
            end
        end
    end
end

local clickCanvas = function(x, y, btn)
    if btn == 1 then
        leftClickCanvas(x, y)
    elseif btn == 2 then
        rightClickCanvas(x, y)
    end
end

draw.update = function(dt)
    if love.mouse.isDown(1) then
        clickCanvas(love.mouse.getX(), love.mouse.getY(), 1)
        clickTileset(love.mouse.getX(), love.mouse.getY(), 1)
    elseif love.mouse.isDown(2) then
        clickCanvas(love.mouse.getX(), love.mouse.getY(), 2)
    end
end

draw.draw = function()
    love.graphics.clear()
    setColor(255,255,255)
    drawBlocks()
    setColor(255,255,255)
    drawCanvas()
    setColor(255,255,255)
    drawTileset()
    setColor(255,255,255)
end

draw.keypressed = function(key)
    if key == "escape" then
        local cmd = require("console.cmdline")
        cmd.console = draw.console
        draw.console.switch(cmd)
    end
end

draw.mousepressed = function(x, y, btn)
    for _, block in ipairs(blocks) do
        if x > block.x and x < block.x + block.w and y > block.y and y < block.y + block.h then
            if selectedBlock then
                selectedBlock.selected = false
            end
            block.selected = true
            selectedBlock = block
            break
        end
    end

end

return draw