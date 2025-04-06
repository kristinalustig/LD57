C = require "content"

I = {}

I.__index = I

function I.new(id, name, discovered, quad1, quad2, quad3)
  
  local self = setmetatable({
      
    id = id,
    name = name,
    description = C.getIngredientDescription(id),
    numUsed = 0,
    discovered = discovered,
    quads = {
        q1 = quad1,
        q2 = quad2,
        q3 = quad3
    }}, I)
  
  return self
  
end

return I