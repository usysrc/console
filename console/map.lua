local map = {}

local data = {}

map.getData = function(x,y)
    return data[x..","..y]
end

map.setData = function(x,y,t)
    data[x..","..y] = t
end


map.setAllData = function(d)
    if not d then return end
    data = d
end

map.getAllData = function()
    return data
end


return map