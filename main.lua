local G = require "gameState"

SCENES = {
    Title = 1,
    Intro = 2,
    Cave = 3,
    Credits = 4,
    Help = 5,
    Encyclopedia = 6
}

local currentScene = SCENES.Title

ISDEBUG = true

function love.load()

    G.load(currentScene)

end

function love.update(dt)

    G.update(dt) --probably only animation will live here

end

function love.draw()

    G.draw()

    if ISDEBUG then
        local mx, my = love.mouse.getPosition()
        love.graphics.printf(mx .. ", " .. my, mx+20, my, 100, "left")
    end

end

function love.mousepressed(x, y, button, istouch, presses)

    G.mousePressed(x, y)

end

function love.mousereleased(x, y, button, istouch, presses)

    G.mouseReleased(x, y)

end

function love.keypressed(key, _, _)

    G.keyPressed(key)
    
end

function love.mousemoved(x, y, dx, dy)

    G.mouseMoved(x, y, dx, dy)

end