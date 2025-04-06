C = require "content"

R = {}
R.__index = R

function R.new(id)

    local self = setmetatable({

        id = id,
        name = nil,
        img = nil,
        description = nil,
        ingredients = nil,
        method = nil,
        discovered = false,
        numMade = 0

    }, R)

    self = C.fillInRecipeBlanks(self)

    return self

end

return R