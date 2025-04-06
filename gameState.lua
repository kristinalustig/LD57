I = require "ingredients"
R = require "recipes"
A = require "adventurers"

G = {}

local ingredients
local recipes
local adventurers
local sceneBackgrounds
local miscAssets
local solidsTexture
local liquidsTexture
local toolsTexture
local adventurerTexture
local textFontLg
local textFontSm
local recipeProcessTexture
local recipeProcesses
local finishedTexture
local blenderBottle
local bowlBag
local panPot

local currentlyHeld
local currentAdventurer
local onCounter
local isGameOver
local visitorPresent
local interactionNumber
local successCount
local showBlender
local showPan
local showLiquids
local whichQuad
local inBlender
local inBowl
local inPan
local blenderState
local panState
local animCounter

local successThreshold1
local successThreshold2

local clickTargets

local mousex
local mousey

local mouseDebugText

local windowWidth, windowHeight

local currentScene

function G.load(cs)

    currentlyHeld = nil
    onCounter = nil
    visitorPresent = false
    isGameOver = false
    interactionNumber = 0
    successCount = 0
    showBlender = true
    showPan = true
    showLiquids = true
    successThreshold1 = 5
    successThreshold2 = 20
    mouseDebugText = ""
    whichQuad = 1
    currentAdventurer = nil
    inBlender = {}
    inBowl = {}
    inPan = {}
    blenderState = 1
    panState = 1
    animCounter = 0

    currentScene = cs

    windowWidth, windowHeight = love.graphics.getDimensions()

    LoadSceneBackgrounds()

    LoadIngredients()

    LoadRecipes()

    LoadRecipeProcess()

    LoadAdventurers()

    LoadSFX()

    LoadMiscAssets()

    LoadClickTargetAreas()

    love.graphics.setFont(textFontLg)

end

function G.update(dt)

    mousex, mousey = love.mouse.getPosition()

    --STRETCH GOAL - animation here
    if currentScene == SCENES.Title then
    elseif currentScene == SCENES.Intro then
    elseif currentScene == SCENES.Cave then

        if visitorPresent == false then
            currentAdventurer = adventurers[ChooseNextVisitor()]
            visitorPresent = true
        else
            if currentAdventurer.alpha < 1 and not currentAdventurer.fullyAppeared then
                currentAdventurer.alpha = currentAdventurer.alpha + .05
            elseif currentAdventurer.alpha >= 1 then
                currentAdventurer.fullyAppeared = true
            elseif currentAdventurer.alpha > 0 and currentAdventurer.fullyAppeared then 
                currentAdventurer.alpha = currentAdventurer.alpha - .05
            elseif currentAdventurer.alpha <= 0 and currentAdventurer.fullyAppeared then
                currentAdventurer.fullyAppeared = false
                currentAdventurer.alpha = 0
                currentAdventurer = nil
                visitorPresent = nil
            end
        end

    elseif currentScene == SCENES.Credits then
    elseif currentScene == SCENES.Help then
    elseif currentScene == SCENES.Encyclopedia then
    end

    if blenderState == 2 and animCounter < 100 then
        animCounter = animCounter + 1
    elseif blenderState == 2 and animCounter >= 100 then
        animCounter = 0
        blenderState = 3
    end

    isGameOver = CheckGameOver()
    if isGameOver then 
        --pull all stats and change scene to credits once transitions are over
    end

end

function G.draw()

    if currentScene == SCENES.Title then

        love.graphics.draw(sceneBackgrounds.title)

    elseif currentScene == SCENES.Intro then
    elseif currentScene == SCENES.Cave then

        love.graphics.draw(sceneBackgrounds.cave)

        --draw adventurer if present
        if visitorPresent then
            love.graphics.setColor(1, 1, 1, currentAdventurer.alpha)
            love.graphics.draw(adventurerTexture, currentAdventurer.quad, currentAdventurer.x, currentAdventurer.y)
            love.graphics.setColor(1, 1, 1, 1)
        end

        love.graphics.draw(miscAssets.counter, 0, 0)
        if showBlender then
            love.graphics.draw(toolsTexture, miscAssets.blenderBack, 0, 280)
        end
        love.graphics.draw(toolsTexture, miscAssets.bowlBack, 160, 300)
        if showPan then
            love.graphics.draw(toolsTexture, miscAssets.pan, 0, 472)
        end

        --draw any ingredients currently in use
        if table.getn(inBowl) > 0 then
            local bowlx = 172
            local bowly = 268
            local inc = 10
            love.graphics.draw(recipeProcessTexture, recipeProcesses.bowl.base, bowlx, bowly)
            for k, v in ipairs(inBowl) do
                if v == 1 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.bowl.toad, bowlx, bowly)
                    love.graphics.draw(solidsTexture, ingredients.toad.quads.q1, bowlx+inc, bowly, 0, .7, .7)
                    inc = inc + 100
                elseif v == 2 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.bowl.lich, bowlx, bowly)
                    love.graphics.draw(solidsTexture, ingredients.lichen.quads.q1, bowlx+inc, bowly, 0, .7, .7)
                    inc = inc + 100
                elseif v == 3 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.bowl.glow, bowlx, bowly)
                    love.graphics.draw(solidsTexture, ingredients.glow.quads.q1, bowlx+inc, bowly, 0, .7, .7)
                    inc = inc + 100
                elseif v == 4 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.bowl.crys, bowlx, bowly)
                    love.graphics.draw(solidsTexture, ingredients.crystal.quads.q1, bowlx+inc, bowly, 0, .7, .7)
                    inc = inc + 100
                end
            end
        end

        if table.getn(inBlender) > 0 then
            local bx = 30
            local by = 312
            local inc = -10
            local useBase = false
            if table.getn(inBlender) == 2 and inBlender[1] <= 4 and inBlender[2] <= 4 then
                useBase = true
            end
            for k, v in ipairs(inBlender) do
                if v == 5 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.fog, bx, by)
                    love.graphics.draw(liquidsTexture, ingredients.fog.quads.q1, bx+inc, by-90, 0, .5, .5)
                    inc = inc + 40
                elseif v == 6 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.drop, bx, by)
                    love.graphics.draw(liquidsTexture, ingredients.drops.quads.q1, bx+inc, by-90, 0, .5, .5)
                    inc = inc + 40
                elseif v == 7 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.tea, bx, by)
                    love.graphics.draw(liquidsTexture, ingredients.tea.quads.q1, bx+inc, by-90, 0, .5, .5)
                    inc = inc + 40
                end
            end
            for k, v in ipairs(inBlender) do
                if v == 1 then
                    if blenderState == 2 and (k == 2 or (k == 1 and not useBase)) then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.toad.spin, bx, by)
                    elseif blenderState == 3 and (k == 2 or (k == 1 and not useBase))then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.toad.done, bx, by)
                    elseif k == 1 and useBase then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.toad.base, bx, by)
                    else
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.toad.whole, bx, by)
                    end
                    love.graphics.draw(solidsTexture, ingredients.toad.quads.q1, bx+inc, by-60, 0, .7, .7)
                    inc = inc + 40
                elseif v == 2 then
                    if blenderState == 2 and (k == 2 or (k == 1 and not useBase)) then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.lich.spin, bx, by)
                    elseif blenderState == 3 and (k == 2 or (k == 1 and not useBase))then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.lich.done, bx, by)
                    elseif k == 1 and useBase then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.lich.base, bx, by)
                    else
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.lich.whole, bx, by)
                    end
                    love.graphics.draw(solidsTexture, ingredients.lichen.quads.q1, bx+inc, by-60, 0, .7, .7)
                    inc = inc + 40
                elseif v == 3 then
                    if blenderState == 2 and (k == 2 or (k == 1 and not useBase)) then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.glow.spin, bx, by)
                    elseif blenderState == 3 and (k == 2 or (k == 1 and not useBase))then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.glow.done, bx, by)
                    elseif k == 1 and useBase then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.glow.base, bx, by)
                    else
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.glow.whole, bx, by)
                    end
                    love.graphics.draw(solidsTexture, ingredients.glow.quads.q1, bx+inc, by-60, 0, .7, .7)
                    inc = inc + 40
                elseif v == 4 then
                    if blenderState == 2 and (k == 2 or (k == 1 and not useBase)) then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.crys.spin, bx, by)
                    elseif blenderState == 3 and (k == 2 or (k == 1 and not useBase))then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.crys.done, bx, by)
                    elseif k == 1 and useBase then
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.crys.base, bx, by)
                    else
                        love.graphics.draw(recipeProcessTexture, recipeProcesses.blender.crys.whole, bx, by)
                    end
                    love.graphics.draw(solidsTexture, ingredients.crystal.quads.q1, bx+inc, by-60, 0, .7, .7)
                    inc = inc + 40
                end
            end
        end

        if table.getn(inPan) > 0 then
            local bx = 70
            local by = 504
            local inc = 10
            for k, v in ipairs(inPan) do
                if v == 1 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.toad, bx, by)
                    love.graphics.draw(solidsTexture, ingredients.toad.quads.q1, bx+inc, by-20, 0, .7, .7)
                    inc = inc + 40
                elseif v == 2 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.lich, bx, by)
                    love.graphics.draw(solidsTexture, ingredients.lichen.quads.q1, bx+inc, by-20, 0, .7, .7)
                    inc = inc + 40
                elseif v == 3 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.glow, bx, by)
                    love.graphics.draw(solidsTexture, ingredients.glow.quads.q1, bx+inc, by-20, 0, .7, .7)
                    inc = inc + 40
                elseif v == 4 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.crys, bx, by)
                    love.graphics.draw(solidsTexture, ingredients.crystal.quads.q1, bx+inc, by-20, 0, .7, .7)
                    inc = inc + 40
                end
            end
        end

        if showBlender then
            love.graphics.draw(toolsTexture, miscAssets.blenderFront, 0, 280)
        end
        love.graphics.draw(toolsTexture, miscAssets.bowlFront, 160, 300)

        if visitorPresent and currentAdventurer.fullyAppeared == true then
            love.graphics.draw(miscAssets.speechBubble, 308, 0)
            love.graphics.setColor(0, 0, 0)
            love.graphics.setFont(textFontLg)
            love.graphics.printf(currentAdventurer.dialog.first, 352, 8, 300, "left")
            love.graphics.printf(currentAdventurer.name, 690, 26, 100, "left")
            love.graphics.setFont(textFontSm)
            love.graphics.printf(currentAdventurer.className, 690, 52, 100, "left")
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill", 696, 100, currentAdventurer.healthPercent*.92, 12)
            love.graphics.setColor(0,0,1)
            love.graphics.rectangle("fill", 696, 136, currentAdventurer.manaPercent*.92, 12)
            love.graphics.setColor(1, 1, 1)
        end

        if showLiquids then
            love.graphics.draw(liquidsTexture, ingredients.fog.quads.q1, 470, 232)
            love.graphics.draw(liquidsTexture, ingredients.drops.quads.q1, 560, 230)
            love.graphics.draw(liquidsTexture, ingredients.tea.quads.q1, 669, 190)
        end

        --draw anything currently being held or sitting on the counter

        love.graphics.draw(miscAssets.enc, 356, 204)
        love.graphics.draw(miscAssets.trash, 752, 228)

        if currentlyHeld ~= nil then
            love.graphics.printf(currentlyHeld.name, mousex, mousey, 100, "center")
            if currentlyHeld.id <= 4 then
                local quad = currentlyHeld.quads.q1
                if whichQuad == 2 then
                    quad = currentlyHeld.quads.q2
                elseif whichQuad == 3 then
                    quad = currentlyHeld.quads.q3
                end
                love.graphics.draw(solidsTexture, quad, mousex, mousey)
            else
                love.graphics.draw(liquidsTexture, currentlyHeld.quads.q2, mousex, mousey-100)
            end
        end

    elseif currentScene == SCENES.Credits then
    elseif currentScene == SCENES.Help then
    elseif currentScene == SCENES.Encyclopedia then
        love.graphics.draw(sceneBackgrounds.encyclopedia1)
    end

    love.graphics.printf(mouseDebugText, 0, 0, 200, "left")

end

--------------------------
--MISC FUNCTIONS
--------------------------

function CheckGameOver()

    return false

end


function ChooseNextVisitor()

    local choices = {}

    if successCount == successThreshold1 then
        return 10
    elseif successCount == successThreshold2 then
        return 10
    elseif successCount < successThreshold1 then
        choices = {
            1, 2, 3, 4
        }
    elseif successCount < successThreshold2 then
        choices = {
            1, 2, 3, 4, 5, 6, 7
        }
    else
        --all visitors eligible
        choices = {
            1, 2, 3, 4, 5, 6, 7, 8, 9, 11
        }
    end

    return 1
    --return choices[love.math.random(table.getn(choices))]

end

function TakeClickAction(n)

    local canPickUp = currentlyHeld == nil

    whichQuad = love.math.random(3)

    if n == "toad" and canPickUp then
        currentlyHeld = ingredients.toad
    elseif n == "glow" and canPickUp then
        currentlyHeld = ingredients.glow
    elseif n == "lich" and canPickUp then
        currentlyHeld = ingredients.lichen
    elseif n == "crys" and canPickUp then
        currentlyHeld = ingredients.crystal
    elseif n == "fog" and canPickUp then
        currentlyHeld = ingredients.fog
    elseif n == "drop" and canPickUp then
        currentlyHeld = ingredients.drops
    elseif n == "tea" and canPickUp then
        currentlyHeld = ingredients.tea
    elseif n == "blend" and canPickUp then
        if table.getn(inBlender) > 0 then
            if blenderState == 1 then
                blenderState = 2
            elseif blenderState == 3 then
                currentlyHeld = finishedProduct
                inBlender = {}
                blenderState = 1
            end
        end
    elseif n == "bowl" and canPickUp then

    elseif n == "pan" and canPickUp then
        panState = 2
    elseif n == "enc" then
        currentlyHeld = nil
        currentScene = SCENES.Encyclopedia
    elseif n == "trash" then
        inBlender = {}
        inBowl = {}
        inPan = {}
        currentlyHeld = nil
    end
end

function TakeDropAction(n)

    local canDropItem = currentlyHeld ~= nil

    if n == "toad" and canDropItem then
        currentlyHeld = nil
    elseif n == "glow" and canDropItem then
        currentlyHeld = nil
    elseif n == "lich" and canDropItem then
        currentlyHeld = nil
    elseif n == "crys" and canDropItem then
        currentlyHeld = nil
    elseif n == "fog" and canDropItem then
        currentlyHeld = nil
    elseif n == "drop" and canDropItem then
        currentlyHeld = nil
    elseif n == "tea" and canDropItem then
        currentlyHeld = nil
    elseif n == "blend" and canDropItem then
        local bc = table.getn(inBlender)
        if bc <= 1 then
            if bc == 1 and inBlender[1] > 4 and currentlyHeld.id > 4 then
                currentlyHeld = nil
                --womp womp
            else
                table.insert(inBlender, currentlyHeld.id)
                currentlyHeld = nil
            end
        else
            currentlyHeld = nil
            --TODO: PLAY WOMP WOMP
        end
    elseif n == "bowl" and canDropItem then
        local bc = table.getn(inBowl)
        if bc <= 1 then
            if currentlyHeld.id <= 4 then
                table.insert(inBowl, currentlyHeld.id)
            else
                --TODO WOMP
            end
        else
            --TODO WOMP
        end
    elseif n == "pan" and canDropItem then
        local pc = table.getn(inPan)
        if pc == 1 then
            if currentlyHeld.id > 4 and inPan[1] > 4 then
                --womp womp
            elseif currentlyHeld.id <= 4 and inPan[1] <= 4 then
                --womp womp
            else
                table.insert(inPan, currentlyHeld.id)
            end
        elseif pc == 0 then
            table.insert(inPan, currentlyHeld.id)
        end
    elseif n == "enc" then
        --drop sth if needed and then open encyclopedia
        currentlyHeld = nil
        currentScene = SCENES.Encyclopedia
    elseif n == "trash" then
        currentlyHeld = nil
    end
end

--------------------------
--EVENT HANDLERS
--------------------------

function G.mousePressed(mx, my)
    if currentScene == SCENES.Title then
    elseif currentScene == SCENES.Intro then
    elseif currentScene == SCENES.Cave then
        for k, v in ipairs(clickTargets) do
            if mx >= v.x and mx <= v.x2 and my >= v.y and my <= v.y2 then
                TakeClickAction(v.name)
                break
            end
        end
    elseif currentScene == SCENES.Credits then
    elseif currentScene == SCENES.Help then
    elseif currentScene == SCENES.Encyclopedia then
        if mx >= 500 and mx <= 750 and my >= 500 and my <= 550 then

        end
    end

end

function G.mouseReleased(mx, my)

    if currentScene == SCENES.Title then
        --is it on the arrow?
    elseif currentScene == SCENES.Intro then
        --is it on the arrow?
    elseif currentScene == SCENES.Cave then
        for k, v in ipairs(clickTargets) do
            if mx >= v.x and mx <= v.x2 and my >= v.y and my <= v.y2 then
                TakeDropAction(v.name)
                break
            end
        end
        currentlyHeld = nil
    elseif currentScene == SCENES.Credits then
        --nothin' here!
    elseif currentScene == SCENES.Help then
        --is it on the return button?
    elseif currentScene == SCENES.Encyclopedia then
        --is it on a page turn?
    end
    
end

function G.keyPressed(key)

    if key == "e" then
        if currentScene == SCENES.Cave then
            currentScene = SCENES.Encyclopedia
        else
            currentScene = SCENES.Cave 
        end
    elseif key == "escape" then
        if currentScene == SCENES.Help or currentScene == SCENES.Encyclopedia then
            currentScene = SCENES.Cave
        elseif currentScene == SCENES.Cave then
            currentScene = SCENES.Help
        end
    elseif key == "t" and currentScene == SCENES.Cave then
        inBlender = {}
        inBowl = {}
        inPan = {}
    end

end

--------------------------
--LOADING IN ASSETS BELOW
--------------------------

function LoadSceneBackgrounds()

    sceneBackgrounds = {
        title = love.graphics.newImage("/assets/title.png"),
        --intro = love.graphics.newImage("/assets/intro.png"),
        cave = love.graphics.newImage("/assets/cave.png"),
        --credits = love.graphics.newImage("/assets/credits.png"),
        --help = love.graphics.newImage("/assets/help.png"),
        encyclopedia1 = love.graphics.newImage("/assets/encyclopedia_1.png"),
        encyclopedia2 = love.graphics.newImage("/assets/encyclopedia_2.png"),
        encyclopedia3 = love.graphics.newImage("/assets/encyclopedia_3.png")
    }

end

function LoadRecipeProcess()

    recipeProcessTexture = love.graphics.newImage("/assets/ingredients.png")
    local mult = 96

    recipeProcesses = {
        blender = {
            toad = {
                base = love.graphics.newQuad(mult*12, mult*1, mult, mult, recipeProcessTexture),
                whole = love.graphics.newQuad(mult*3, mult*0, mult, mult, recipeProcessTexture),
                spin = love.graphics.newQuad(mult*4, mult*0, mult, mult, recipeProcessTexture),
                done = love.graphics.newQuad(mult*5, mult*0, mult, mult, recipeProcessTexture),
            },
            glow = {
                base = love.graphics.newQuad(mult*13, mult*1, mult, mult, recipeProcessTexture),
                whole = love.graphics.newQuad(mult*6, mult*0, mult, mult, recipeProcessTexture),
                spin = love.graphics.newQuad(mult*7, mult*0, mult, mult, recipeProcessTexture),
                done = love.graphics.newQuad(mult*8, mult*0, mult, mult, recipeProcessTexture),
            },
            lich = {
                base = love.graphics.newQuad(mult*14, mult*1, mult, mult, recipeProcessTexture),
                whole = love.graphics.newQuad(mult*9, mult*0, mult, mult, recipeProcessTexture),
                spin = love.graphics.newQuad(mult*10, mult*0, mult, mult, recipeProcessTexture),
                done = love.graphics.newQuad(mult*11, mult*0, mult, mult, recipeProcessTexture),
            },
            crys = {
                base = love.graphics.newQuad(mult*15, mult*1, mult, mult, recipeProcessTexture),
                whole = love.graphics.newQuad(mult*12, mult*0, mult, mult, recipeProcessTexture),
                spin = love.graphics.newQuad(mult*13, mult*0, mult, mult, recipeProcessTexture),
                done = love.graphics.newQuad(mult*14, mult*0, mult, mult, recipeProcessTexture),
            },
            fog = love.graphics.newQuad(mult*0, mult*0, mult, mult, recipeProcessTexture),
            drop = love.graphics.newQuad(mult*2, mult*0, mult, mult, recipeProcessTexture),
            tea = love.graphics.newQuad(mult*1, mult*0, mult, mult, recipeProcessTexture),
            trash = love.graphics.newQuad(mult*15, mult*0, mult, mult, recipeProcessTexture)
        },
        bowl = {
            base = love.graphics.newQuad(mult*0, mult*1, mult*2, mult, recipeProcessTexture),
            toad = love.graphics.newQuad(mult*2, mult*1, mult*2, mult, recipeProcessTexture),
            glow = love.graphics.newQuad(mult*4, mult*1, mult*2, mult, recipeProcessTexture),
            crys = love.graphics.newQuad(mult*8, mult*1, mult*2, mult, recipeProcessTexture),
            lich = love.graphics.newQuad(mult*6, mult*1, mult*2, mult, recipeProcessTexture),
            trash = love.graphics.newQuad(mult*10, mult*1, mult*2, mult, recipeProcessTexture)
        },
        pan = {
            toad = love.graphics.newQuad(mult*0, mult*2, mult*2, mult, recipeProcessTexture),
            glow = love.graphics.newQuad(mult*2, mult*2, mult*2, mult, recipeProcessTexture),
            crys = love.graphics.newQuad(mult*6, mult*2, mult*2, mult, recipeProcessTexture),
            lich = love.graphics.newQuad(mult*4, mult*2, mult*2, mult, recipeProcessTexture),
            fog = love.graphics.newQuad(mult*8, mult*2, mult*2, mult, recipeProcessTexture),
            drop = love.graphics.newQuad(mult*12, mult*2, mult*2, mult, recipeProcessTexture),
            tea = love.graphics.newQuad(mult*10, mult*2, mult*2, mult, recipeProcessTexture),
            trash = love.graphics.newQuad(mult*14, mult*2, mult*2, mult, recipeProcessTexture)
        }
    }


    finishedTexture = love.graphics.newImage("/assets/finished.png")

    blenderBottle = love.graphics.newQuad(0, 0, 96, 96, finishedTexture)
    bowlBag = love.graphics.newQuad(0, 96, 96, 96, finishedTexture)
    panPot = love.graphics.newQuad(0, 192, 96, 96, finishedTexture)


end

function LoadIngredients()

    solidsTexture = love.graphics.newImage("/assets/foraged.png")
    liquidsTexture = love.graphics.newImage("/assets/bottles.png")

    ingredients = {
        toad = I.new(1, "Pink Toadstool", true, love.graphics.newQuad(0, 0, 64, 64, solidsTexture), love.graphics.newQuad(64, 0, 64, 64, solidsTexture), love.graphics.newQuad(128, 0, 64, 64, solidsTexture)),
        lichen = I.new(2, "Cave Lichen", true, love.graphics.newQuad(0, 128, 64, 64, solidsTexture), love.graphics.newQuad(64, 128, 64, 64, solidsTexture), love.graphics.newQuad(128, 128, 64, 64, solidsTexture)),
        glow = I.new(3, "Glowshroom", true, love.graphics.newQuad(0, 64, 64, 64, solidsTexture), love.graphics.newQuad(64, 64, 64, 64, solidsTexture), love.graphics.newQuad(128, 64, 64, 64, solidsTexture)),
        crystal = I.new(4, "Crystallite", true, love.graphics.newQuad(0, 192, 64, 64, solidsTexture), love.graphics.newQuad(64, 192, 64, 64, solidsTexture), love.graphics.newQuad(128, 192, 64, 64, solidsTexture)),
        fog = I.new(5, "Essence of Fog", false, love.graphics.newQuad(0, 128, 128, 128, liquidsTexture), love.graphics.newQuad(128, 128, 128, 128, liquidsTexture), nil),
        drops = I.new(6, "Stalactite Drops", false, love.graphics.newQuad(0, 0, 128, 128, liquidsTexture), love.graphics.newQuad(128, 0, 128, 128, liquidsTexture), nil),
        tea = I.new(7, "Rootbark Tea", false, love.graphics.newQuad(0, 256, 64, 192, liquidsTexture), love.graphics.newQuad(64, 256, 192, 64, liquidsTexture), nil)
    }

end

function LoadRecipes()

    recipes = {}

    for i=1, 50, 1 do 
        table.insert(recipes, R.new(i))
    end

end

function LoadAdventurers()

    adventurerTexture = love.graphics.newImage("/assets/visitors.png")
    local mult = 64

    adventurers = {
        A.new(1, "Waldorf", "Wizard", love.graphics.newQuad(0, 0, mult*4, mult*4, adventurerTexture), 0, 30),
        A.new(2, "Hurgle", "Warrior", love.graphics.newQuad(0, mult*4, mult*5, mult*5, adventurerTexture), 0, 0),
        A.new(3, "Sporseesa", "Warlock", love.graphics.newQuad(0, mult*10, mult*3, mult*4, adventurerTexture), 0, 0),
        A.new(4, "Kronkle", "Knight", love.graphics.newQuad(0, mult*14, mult*5, mult*5, adventurerTexture), 0, 0),
        A.new(5, "Jolie", "Mage", love.graphics.newQuad(0, mult*19, mult*4, mult*4, adventurerTexture), 0, 0),
        A.new(6, "Mippie", "Star Fighter", love.graphics.newQuad(0, mult*23, mult*4, mult*4, adventurerTexture), 0, 0),
        A.new(7, "XB-394Q", "Backup", love.graphics.newQuad(0, mult*27, mult*4, mult*5, adventurerTexture), 0, 0),
        A.new(8, "Willow", "Rogue", love.graphics.newQuad(0, mult*32, mult*4, mult*4, adventurerTexture), 0, 0),
        A.new(9, "Gargaro", "Archer", love.graphics.newQuad(0, mult*36, mult*4, mult*3, adventurerTexture), 0, 0),
        A.new(10, "???", "???", love.graphics.newQuad(0, mult*39, mult*4, mult*2, adventurerTexture), 0, 0),
        A.new(11, "King Steve", "Supervisor", love.graphics.newQuad(0, mult*41, mult*4, mult*4, adventurerTexture), 0, 0)
    }

end

function LoadSFX()

end

function LoadMiscAssets()

    toolsTexture = love.graphics.newImage("/assets/tools.png")
    local mult = 64

    miscAssets = {
        counter = love.graphics.newImage("/assets/counter.png"),
        speechBubble = love.graphics.newImage("/assets/bubble.png"),
        bowlFront = love.graphics.newQuad(mult*3, mult*3, mult*3, mult*2, toolsTexture),
        bowlBack = love.graphics.newQuad(0, mult*3, mult*3, mult, toolsTexture),
        blenderFront = love.graphics.newQuad(mult*2, 0, mult*2, mult*3, toolsTexture),
        blenderBack = love.graphics.newQuad(0, 0, mult*2, mult*3, toolsTexture),
        pan = love.graphics.newQuad(0, mult*5, mult*5, mult*2, toolsTexture),
        enc = love.graphics.newImage("/assets/enc-sm.png"),
        trash = love.graphics.newImage("/assets/trash.png")
    }

    textFontLg = love.graphics.newFont("/assets/Macondo-Regular.ttf", 24)
    textFontSm = love.graphics.newFont("/assets/Macondo-Regular.ttf", 16)

end

function LoadClickTargetAreas()

    clickTargets = {}

    table.insert(clickTargets, {
        name = "toad",
        x = 406,
        y = 429,
        x2 = 500,
        y2 = 548 
    })

    table.insert(clickTargets, {
        name = "glow",
        x = 524,
        y = 470,
        x2 = 600,
        y2 = 600
    })
    
    table.insert(clickTargets, {
        name = "lich",
        x = 630,
        y = 420,
        x2 = 716,
        y2 = 590 })

    table.insert(clickTargets, {
        name = "crys",
        x = 730,
        y = 470,
        x2 = 800,
        y2 = 600 })

    table.insert(clickTargets, {
        name = "fog",
        x = 500,
        y = 242,
        x2 = 570,
        y2 = 360 })

    table.insert(clickTargets, {
        name = "drop",
        x = 592,
        y = 231,
        x2 = 664,
        y2 = 356 })

    table.insert(clickTargets, {
        name = "tea",
        x = 678,
        y = 195,
        x2 = 725,
        y2 = 382 })

    table.insert(clickTargets, {
        name = "blend",
        x = 6,
        y = 290,
        x2 = 130,
        y2 = 470 })

    table.insert(clickTargets, {
        name = "bowl",
        x = 160,
        y = 316,
        x2 = 350,
        y2 = 420 })

    table.insert(clickTargets, {
        name = "pan",
        x = 0,
        y = 490,
        x2 = 320,
        y2 = 600 })

    table.insert(clickTargets, {
        name = "enc",
        x = 366,
        y = 204,
        x2 = 442,
        y2 = 300 })

    table.insert(clickTargets, {
        name = "trash",
        x = 752,
        y = 228,
        x2 = 800,
        y2 = 336 })

end

return G