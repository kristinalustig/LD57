A = {}
A.__index = A

function A.new(id, name, className, quad, x, y)

    local self = setmetatable({

        id = id,
        name = name,
        className = className,
        imgRow = id,
        dialog = C.getDialog(id),
        currentDialog = "",
        appearanceNum = 0,
        successNum = 0,
        lastTime = nil,
        healthPercent = 100,
        manaPercent = 100,
        quad = quad,
        alpha = 0,
        fullyAppeared = false,
        x = x,
        y = y

    }, A)

    return self

end

return A