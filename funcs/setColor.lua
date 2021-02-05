local setColor = function(a, b, c, d)
    if type(a) == 'table' then
        love.graphics.setColor(a[1]/255, a[2]/255, a[3]/255)
    elseif type(a) == 'number' and b and c then
        love.graphics.setColor(a/255, b/255, c/255, (d or 255)/255)
    end
end

return setColor