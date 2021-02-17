local mouseOver = function(btn, x, y)
    return x > btn.x and x < btn.x + btn.w and y > btn.y and y < btn.y + btn.h
end

return mouseOver