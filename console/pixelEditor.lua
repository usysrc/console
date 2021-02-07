local serialize = require 'lib.ser'
local t = require "funcs.table"
local all, del, add = t.all, t.del, t.add

local objects = {}

local draw = {}
local setColor = require "funcs.setColor"

local status = ""

local palette = require "palettes.picodb"

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

local cartFileName = "game.cart"
local cartsFolder = "carts/"

local saveTileset = function()
    return tileset
end

local loadTileset = function()
    if not love.filesystem.getInfo(cartsFolder..cartFileName) then
        return
    end
    -- local savedata = love.filesystem.read()
    cart = love.filesystem.load(cartsFolder..cartFileName)()
    tileset = cart.tileset
    draw.console.game.code = cart.code
    canvas = tileset["1,1"]
end

local saveGame = function()
    local cart = {}
    cart.code = draw.console.game.code
    cart.tileset = saveTileset()
    love.filesystem.write(cartsFolder..cartFileName, serialize(cart))
end

local drawTilesetTiles = function()
    setColor(255,255,255)
    love.graphics.draw(tilesetCanvas)
end

local drawTilesetMarker = function()
    local currentCanvas = canvas
    local ox, oy = tilesetOffsetX, tilesetOffsetY
    love.graphics.setLineWidth(2)
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            if currentCanvas == tileset[x..","..y] then
                setColor(255,255,255)
                love.graphics.rectangle("line", ox+x*w, oy+y*h, w+2, h+2)
                break
            end
        end
    end
    love.graphics.setLineWidth(1)
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

local move = function(tx, ty)
    local newCanvas = {}
    for i=1, w do
        for j=1,h do
            local col = canvas[i..","..j]
            local ti, tj = i + tx, j + ty
            if ti < 1 then ti = w end
            if ti > w then ti = 1 end
            if tj < 1 then tj = h end
            if tj > h then tj = 1 end
            newCanvas[ti..","..tj] = col
        end
    end
    local px,py = 0, 0
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            if canvas == tileset[x..","..y] then
                px, py = x, y
            end
        end
    end
    canvas = newCanvas

    if px ~= 0 and py ~= 0 then
        tileset[px..","..py] = canvas
    end
    drawTilesetTilesToCanvas()
end

local moveLeft = function()
    move(-1, 0)
end
local moveRight = function()
    move(1, 0)
end
local moveUp = function()
    move(0, -1)
end
local moveDown = function()
    move(0, 1)
end

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
    for item in all(objects) do
        item:draw()
    end
end

draw.save = function(name)
    cartFileName = name or cartFileName
    saveTileset()
end

draw.load = function(name)
    cartFileName = name or cartFileName
    loadTileset()
end

local addSaveText = function()
    local o = {}
    o.t = 0
    o.draw = function(self)
        self.t = self.t + 1
        if self.t > 60 then
            del(objects, self)
        end
        love.graphics.print("SAVED AS "..cartFileName)
    end
    add(objects, o)
end

draw.keypressed = function(key)
    if key == "escape" then
        draw.console.switch(draw.console.cmdline)
    end
    if key == "left" then
        moveLeft()
    end
    if key == "right" then
        moveRight()
    end
    if key == "up" then
        moveUp()
    end
    if key == "down" then
        moveDown()
    end
    if key == "s" then
        saveGame()
        addSaveText()
    end
    if key == "r" then
        draw.console.game.runCode()
        draw.console.switch(draw.console.game)
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

draw.init = function(console)
    draw.console = console
    for x = 1, tilesetWidth do
        for y = 1, tilesetHeight do
            initCanvas(tileset[x..","..y])
        end
    end
    loadTileset()
    drawTilesetTilesToCanvas()
end

draw.getTileset = function()
    return tileset
end

draw.getPalette = function()
    return palette
end

return draw