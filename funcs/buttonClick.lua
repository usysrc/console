local mouseOver = require("funcs.mouseOver")

local buttonClick = function(btn, x, y)
    if mouseOver(btn, x, y) then
        if btn.onClick then btn.onClick(); return true end
    end
end

return buttonClick