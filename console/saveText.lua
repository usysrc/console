local saveAndLoad = require("console.saveAndLoad")

local add = function(objects)
    local o = {}
    o.t = 0
    o.draw = function(self)
        self.t = self.t + 1
        if self.t > 60 then
            del(objects, self)
        end
        love.graphics.print("SAVED AS "..saveAndLoad.getCartFileName(),0,16)
    end
    add(objects, o)
end

return {
    add = add
}