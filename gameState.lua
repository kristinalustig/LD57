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
local textFontMd
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
local bowlState
local animCounter
local noticeText
local noticeTextTimer
local currentEncyclopediaPage
local hoverText
local goodText
local goodTextTimer
local lastVisited
local phrases
local tenTimer

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
    showBlender = false
    showPan = false
    showLiquids = false
    successThreshold1 = 4
    successThreshold2 = 20
    mouseDebugText = ""
    whichQuad = 1
    currentAdventurer = nil
    inBlender = {}
    inBowl = {}
    inPan = {}
    blenderState = 1
    panState = 1
    bowlState = 1
    animCounter = 0
    noticeText = ""
    noticeTextTimer = 100
    goodTextTimer = 100
    currentEncyclopediaPage = 1
    hoverText = ""
    goodText = ""
    lastVisited = 0
    tenTimer = 300

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
            currentAdventurer = ChooseNextVisitor()
            if currentAdventurer == nil then
                currentScene = SCENES.Credits
            end
            visitorPresent = true
        else
            --first shows up
            if currentAdventurer.alpha < 1 and not currentAdventurer.fullyAppeared then
                currentAdventurer.alpha = currentAdventurer.alpha + .05
            --has fully shown up
            elseif currentAdventurer.alpha >= 1 then
                currentAdventurer.fullyAppeared = true
                if currentAdventurer.id == 10 then
                    tenTimer = tenTimer - 1
                    if tenTimer <= 0 then
                        currentAdventurer.alpha = .95
                        tenTimer = 100
                        successCount = successCount + 1
                    end
                end
            --is on their way out
            elseif currentAdventurer.alpha > 0 and currentAdventurer.fullyAppeared then 
                currentAdventurer.alpha = currentAdventurer.alpha - .05
            --fully left
            elseif currentAdventurer.alpha <= 0 and currentAdventurer.fullyAppeared then
                currentAdventurer.fullyAppeared = false
                currentAdventurer.alpha = 0
                lastVisited = currentAdventurer.id
                currentAdventurer = nil
                visitorPresent = false
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

    if bowlState == 2 and animCounter < 100 then
        animCounter = animCounter + 1
    elseif bowlState == 2 and animCounter >= 100 then
        animCounter = 0
        bowlState = 3
    end

    if panState == 2 and animCounter < 100 then
        animCounter = animCounter + 1
    elseif panState == 2 and animCounter >= 100 then
        animCounter = 0
        panState = 3
    end

    if noticeText ~= "" then
        noticeTextTimer = noticeTextTimer - 1
        if noticeTextTimer == 0 then
            noticeText = ""
            noticeTextTimer = 100
        end
    end

    if goodText ~= "" then
        hoverText = ""
        noticeText = ""
        noticeTextTimer = 100
        goodTextTimer = goodTextTimer - 1
        if goodTextTimer == 0 then
            goodText = ""
            goodTextTimer = 100
        end
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

        love.graphics.draw(sceneBackgrounds.intro)

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
            for k, v in ipairs(inPan) do
                if v == 5 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.fog, bx, by)
                    love.graphics.draw(liquidsTexture, ingredients.fog.quads.q1, bx+inc, by-30, 0, .5, .5)
                    inc = inc + 40
                elseif v == 6 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.drop, bx, by)
                    love.graphics.draw(liquidsTexture, ingredients.drops.quads.q1, bx+inc, by-30, 0, .5, .5)
                    inc = inc + 40
                elseif v == 7 then
                    love.graphics.draw(recipeProcessTexture, recipeProcesses.pan.tea, bx, by)
                    love.graphics.draw(liquidsTexture, ingredients.tea.quads.q1, bx+inc, by-40, 0, .5, .5)
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
            love.graphics.setFont(textFontMd)
            love.graphics.printf(currentAdventurer.currentDialog, 352, 7, 316, "left")
            love.graphics.printf(currentAdventurer.name, 690, 26, 100, "left")
            love.graphics.setFont(textFontSm)
            love.graphics.printf(currentAdventurer.className, 690, 52, 100, "left")
            love.graphics.setColor(1,0,0)
            if currentAdventurer.id == 10 then
                love.graphics.rectangle("fill", 696, 100, love.math.random(100)*.92, 12)
                love.graphics.setColor(0,0,1)
                love.graphics.rectangle("fill", 696, 136, love.math.random(100)*.92, 12)
            else
                love.graphics.rectangle("fill", 696, 100, currentAdventurer.healthPercent*.92, 12)
                love.graphics.setColor(0,0,1)
                love.graphics.rectangle("fill", 696, 136, currentAdventurer.manaPercent*.92, 12)
            end
            love.graphics.setColor(1, 1, 1)
        end

        if showLiquids then
            if currentlyHeld == nil or currentlyHeld.id ~= 5 then
                love.graphics.draw(liquidsTexture, ingredients.fog.quads.q1, 470, 232)
            end
            if currentlyHeld == nil or currentlyHeld.id ~= 6 then
                love.graphics.draw(liquidsTexture, ingredients.drops.quads.q1, 560, 230)
            end
            if currentlyHeld == nil or currentlyHeld.id ~= 7 then
                love.graphics.draw(liquidsTexture, ingredients.tea.quads.q1, 669, 190)
            end
        end

        --draw anything currently being held or sitting on the counter

        love.graphics.draw(miscAssets.enc, 356, 204)
        love.graphics.draw(miscAssets.trash, 752, 228)

        if table.getn(blenderBottle.ingreds) > 0 then
            if currentlyHeld == nil or currentlyHeld ~= blenderBottle then
                love.graphics.draw(finishedTexture, blenderBottle.quad, blenderBottle.x, blenderBottle.y)
                DrawFinishedProduct(blenderBottle, blenderBottle.x, blenderBottle.y)
            end
        end
        if table.getn(bowlBag.ingreds) > 0 then
            if currentlyHeld == nil or currentlyHeld ~= bowlBag then
                love.graphics.draw(finishedTexture, bowlBag.quad, bowlBag.x, bowlBag.y)
                DrawFinishedProduct(bowlBag, bowlBag.x, bowlBag.y)
            end
        end
        if table.getn(panPot.ingreds) > 0 then
            if currentlyHeld == nil or currentlyHeld ~= panPot then
                love.graphics.draw(finishedTexture, panPot.quad, panPot.x, panPot.y)
                DrawFinishedProduct(panPot, panPot.x, panPot.y)
            end
        end

        if currentlyHeld ~= nil then
            if currentlyHeld.id <= 4 then
                local quad = currentlyHeld.quads.q1
                if whichQuad == 2 then
                    quad = currentlyHeld.quads.q2
                elseif whichQuad == 3 then
                    quad = currentlyHeld.quads.q3
                end
                love.graphics.draw(solidsTexture, quad, mousex, mousey)
            elseif currentlyHeld.id >= 100 then
                DrawFinishedProduct(currentlyHeld, mousex, mousey - 40)
            else
                love.graphics.draw(liquidsTexture, currentlyHeld.quads.q2, mousex, mousey-100)
            end
        end

        if noticeText ~= "" then
            love.graphics.setColor(255/255, 204/255, 208/255, noticeTextTimer / 40)
            love.graphics.rectangle("fill", 0, 570, 800, 30)
            love.graphics.setColor(0, 0, 0, noticeTextTimer / 40)
            love.graphics.setFont(textFontLg)
            love.graphics.printf(noticeText, 10, 572, 780, "center")
            love.graphics.setColor(1, 1, 1)
        elseif goodText ~= "" then
            love.graphics.setColor(140/255, 255/255, 155/255, goodTextTimer / 40)
            love.graphics.rectangle("fill", 0, 570, 800, 30)
            love.graphics.setColor(0, 0, 0, goodTextTimer / 40)
            love.graphics.setFont(textFontLg)
            love.graphics.printf(goodText, 10, 572, 780, "center")
            love.graphics.setColor(1, 1, 1)
        elseif hoverText ~= "" then
            love.graphics.setColor(140/255, 218/255, 255/255)
            love.graphics.rectangle("fill", 0, 570, 800, 30)
            love.graphics.setColor(0, 0, 0)
            love.graphics.setFont(textFontLg)
            love.graphics.printf(hoverText, 10, 572, 780, "center")
            love.graphics.setColor(1, 1, 1)
        end

    elseif currentScene == SCENES.Credits then
    elseif currentScene == SCENES.Help then
    elseif currentScene == SCENES.Encyclopedia then
        if successCount > successThreshold1 then
            love.graphics.draw(sceneBackgrounds.encyclopedia[currentEncyclopediaPage])
        else
            love.graphics.draw(sceneBackgrounds.encyclopediaEarly)
        end
    end

    love.graphics.printf(mouseDebugText, 0, 0, 200, "left")

end

--------------------------
--MISC FUNCTIONS
--------------------------

function DrawFinishedProduct(prod, x, y)

    local incr = 0
    love.graphics.draw(finishedTexture, prod.quad, x, y)
    if prod.ingreds[1] == 1 or prod.ingreds[2] == 1 then
        love.graphics.draw(solidsTexture, ingredients.toad.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .5, .5)
        incr = incr + 30
    end
    if prod.ingreds[1] == 2 or prod.ingreds[2] == 2 then
        love.graphics.draw(solidsTexture, ingredients.lichen.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .5, .5)
        incr = incr + 30
    end
    if prod.ingreds[1] == 3 or prod.ingreds[2] == 3 then
        love.graphics.draw(solidsTexture, ingredients.glow.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .5, .5)
        incr = incr + 30
    end
    if prod.ingreds[1] == 4 or prod.ingreds[2] == 4 then
        love.graphics.draw(solidsTexture, ingredients.crystal.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .5, .5)
        incr = incr + 30
    end
    if prod.ingreds[1] == 5 or prod.ingreds[2] == 5 then
        love.graphics.draw(liquidsTexture, ingredients.fog.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .25, .25)
        incr = incr + 30
    end
    if prod.ingreds[1] == 6 or prod.ingreds[2] == 6 then
        love.graphics.draw(liquidsTexture, ingredients.drops.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .25, .25)
        incr = incr + 30
    end
    if prod.ingreds[1] == 7 or prod.ingreds[2] == 7 then
        love.graphics.draw(liquidsTexture, ingredients.tea.quads.q1, x + prod.offsetX + incr, y + prod.offsetY, 0, .25, .25)
        incr = incr + 30
    end

end

function CheckGameOver()

    return false

end

function ChooseNextVisitor()

    local choices = ChooseEligibleVisitors()
    local pickNum
    local visitor

    if choices ~= 10 then

        if table.getn(choices) == 0 then
            return nil
        end

        pickNum = choices[love.math.random(table.getn(choices))]
        visitor = adventurers[pickNum]
    else
        local pickNum = 10
        if successCount == successThreshold1 then
            adventurers[pickNum].currentDialog = adventurers[pickNum].dialog.first
            showBlender = true
            showLiquids = true
        elseif successCount  == successThreshold2 then
            adventurers[pickNum].currentDialog = adventurers[pickNum].dialog.second
            showPan = true
        end

        return adventurers[pickNum]
    end

    adventurers[pickNum].appearanceNum = adventurers[pickNum].appearanceNum + 1

    local dialog = ""
    if visitor.lastTime == nil then
        dialog = dialog .. visitor.dialog.first
    elseif visitor.lastTime == "bad" then
        dialog = dialog .. visitor.dialog.lostStats
    else
        dialog = dialog .. visitor.dialog.keptStats
    end
    dialog = dialog .. " "..visitor.dialog.flavor[visitor.successNum+1].." "
    dialog = dialog .. visitor.dialog.requestStart.. " " .. GetRandomDesc(visitor.dialog.recipeIds[visitor.successNum+1]) .. ". " .. visitor.dialog.requestEnd

    adventurers[pickNum].currentDialog = dialog
    adventurers[pickNum].manaPercent = love.math.random(100)

    return visitor

end

function GetRandomDesc(rid)

    local recipe = recipes[rid]
    local i1 = string.sub(recipe.ingredients, 1, 1)
    local i2 = string.sub(recipe.ingredients, 2, 2)

    local desc = "a "

    if recipe.method == 1 then
        desc = desc .. "salad that "
    elseif recipe.method == 2 then
        desc = desc .. "potion that "
    else
        desc = desc .. "stew that "
    end
    if i1 == i2 then
        desc = desc .. GetIngredientPhrase(i1, 1) .. " and ".. GetIngredientPhrase(i2, love.math.random(2, 5))
    else
        desc = desc .. GetIngredientPhrase(i1, love.math.random(5)) .. " and ".. GetIngredientPhrase(i2, love.math.random(5))
    end

    return desc

end

function GetIngredientPhrase(id, n)

    if id == "1" then
        return phrases[1][n]
    elseif id == "2" then
        return phrases[2][n]
    elseif id == "3" then
        return phrases[3][n]
    elseif id == "4" then
        return phrases[4][n]
    elseif id == "5" then
        return phrases[5][n]
    elseif id == "6" then
        return phrases[6][n]
    elseif id == "7" then
        return phrases[7][n]
    end

end

function ChooseEligibleVisitors()

    local choices = {}

    if successCount == successThreshold1 then
        return 10
    elseif successCount == successThreshold2 then
        return 10
    elseif successCount < successThreshold1 then
        local tempChoices = {
            2, 4, 5, 9
        }
        for k, v in ipairs(tempChoices) do
            if adventurers[v].successNum < 2 then
                table.insert(choices, v)
            end
        end
    elseif successCount < successThreshold2 then
        if adventurers[1].successNum < 4 then
            table.insert(choices, 1)
        elseif adventurers[2].successNum < 3 then
            table.insert(choices, 2)
        elseif adventurers[3].successNum < 1 then
            table.insert(choices, 3)
        elseif adventurers[4].successNum < 4 then
            table.insert(choices, 4)
        elseif adventurers[5].successNum < 5 then
            table.insert(choices, 5)
        elseif adventurers[6].successNum < 2 then
            table.insert(choices, 6)
        elseif adventurers[7].successNum < 2 then
            table.insert(choices, 7)
        elseif adventurers[8].successNum < 2 then
            table.insert(choices, 8)
        elseif adventurers[9].successNum < 3 then
            table.insert(choices, 9)
        elseif adventurers[11].successNum < 2 then
            table.insert(choices, 11)
        end
    else
        local tempChoices = {
            1, 2, 3, 4, 5, 6, 7, 8, 9, 11
        }
        for k, v in ipairs(tempChoices) do
            if adventurers[v].successNum < 5 then
                table.insert(choices, v)
            end
        end
    end

    local choicesCheckedForHealth = {}
    for k, v in ipairs(choices) do
        if adventurers[v].healthPercent > 0 and v ~= lastVisited then
            table.insert(choicesCheckedForHealth, v)
        end
    end

    return choicesCheckedForHealth

end

function SubmitProduct()

    local recipeMadeId = IdentifyRecipe(currentlyHeld.ingreds[1], currentlyHeld.ingreds[2], false)

    currentlyHeld = nil
    blenderBottle.ingreds = {}
    panPot.ingreds = {}
    bowlBag.ingreds = {}

    --check if correct
    for k, v in ipairs(currentAdventurer.dialog.recipeIds) do
        if v == recipeMadeId and k == currentAdventurer.successNum + 1 then 
            currentAdventurer.successNum = currentAdventurer.successNum + 1
            currentAdventurer.lastTime = "good"
            currentAdventurer.alpha = .99
            goodText = "Recipe was correct!"
            return true
        end
    end

    currentAdventurer.healthPercent = currentAdventurer.healthPercent - 25
    noticeText = "Recipe was incorrect!"
    currentAdventurer.lastTime = "bad"
    currentAdventurer.alpha = .99

    return false

end

function IdentifyRecipe(a, b, shareInfo)

    local searchFor

    if a < b then
        searchFor = a..b 
    else
        searchFor = b..a 
    end

    for k, v in ipairs(recipes) do
        if v.ingredients == searchFor then 
            if v.discovered == false and showInfo then
                goodText = "Discovered new recipe: "..v.name
            elseif showInfo then
                goodText = "Cooked up "..v.name.." again!"
            end
            v.numMade = v.numMade + 1
            return v.id
        end
    end

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
        if table.getn(inBlender) > 1 then
            if blenderState == 1 then
                blenderState = 2
            elseif blenderState == 3 then
                blenderBottle.ingreds = inBlender
                IdentifyRecipe(blenderBottle.ingreds[1], blenderBottle.ingreds[2], true)
                currentlyHeld = blenderBottle
                inBlender = {}
                blenderState = 1
            end
        end
    elseif n == "bowl" and canPickUp then
        if table.getn(inBowl) > 1 then
            if bowlState == 1 then
                bowlState = 2
            elseif bowlState == 3 then
                bowlBag.ingreds = inBowl
                IdentifyRecipe(bowlBag.ingreds[1], bowlBag.ingreds[2], true)
                currentlyHeld = bowlBag
                inBowl = {}
                bowlState = 1
            end
        end
    elseif n == "pan" and canPickUp then
        if table.getn(inPan) > 1 then
            if panState == 1 then
                panState = 2
            elseif panState == 3 then
                panPot.ingreds = inPan
                IdentifyRecipe(panPot.ingreds[1], panPot.ingreds[2], true)
                currentlyHeld = panPot
                inPan = {}
                panState = 1
            end
        end
    elseif n == "enc" then
        currentlyHeld = nil
        currentScene = SCENES.Encyclopedia
    elseif n == "trash" then
        inBlender = {}
        inBowl = {}
        inPan = {}
        currentlyHeld = nil
    elseif n == "bottle" and canPickUp and table.getn(blenderBottle.ingreds) > 0 then
        currentlyHeld = blenderBottle
    elseif n == "bag" and canPickUp and table.getn(bowlBag.ingreds) > 0 then
        currentlyHeld = bowlBag
    elseif n == "pot" and canPickUp and table.getn(panPot.ingreds) > 0 then
        currentlyHeld = panPot
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
        if bc <= 1 and blenderState == 1 then
            if bc == 1 and inBlender[1] > 4 and currentlyHeld.id > 4 and currentlyHeld.id <= 7 then
                currentlyHeld = nil
                noticeText = 'no recipes contain only liquids. press T to trash in-progress recipes.'
                --womp womp
            else
                table.insert(inBlender, currentlyHeld.id)
                currentlyHeld = nil
            end
        else
            currentlyHeld = nil
            noticeText = 'this blender already contains two ingredients. press T to trash in-progress recipes.'
            --TODO: PLAY WOMP WOMP
        end
    elseif n == "bowl" and canDropItem then
        local bc = table.getn(inBowl)
        if bc <= 1 then
            if currentlyHeld.id <= 4 then
                table.insert(inBowl, currentlyHeld.id)
            elseif currentlyHeld ~= nil and currentlyHeld ~= bowlBag then
                noticeText = 'you can only use solid ingredients in the salad bowl.'
                --TODO WOMP
            end
        else
            noticeText = 'this bowl already contains two ingredients. press T to trash in-progress recipes.'
            currentlyHeld = nil
            --TODO WOMP
        end
    elseif n == "pan" and canDropItem then
        local pc = table.getn(inPan)
        if pc == 1 then
            if currentlyHeld.id > 4 and inPan[1] > 4 then
                --womp womp
                noticeText = 'no recipes contain only liquids. press T to trash in-progress recipes.'
            else
                table.insert(inPan, currentlyHeld.id)
                currentlyHeld = nil
            end
        elseif pc == 0 then
            table.insert(inPan, currentlyHeld.id)
            currentlyHeld = nil
        else
            noticeText = 'this bowl already contains two ingredients. press T to trash in-progress recipes.'
            --womp womp
            currentlyHeld = nil
        end
    elseif n == "enc" then
        --drop sth if needed and then open encyclopedia
        currentlyHeld = nil
        currentScene = SCENES.Encyclopedia
    elseif n == "trash" then
        currentlyHeld = nil
    end
end

function TakeHoverAction(n)
    if n == "toad" then
        hoverText = "Pink toadstool"
    elseif n == "glow" then
        hoverText = "Glowshroom"
    elseif n == "lich" then
        hoverText = "Cave lichen"
    elseif n == "crys" then
        hoverText = "Crystallite"
    elseif n == "fog" then
        hoverText = "Essence of fog"
    elseif n == "drop" then
        hoverText = "Stalactite drops"
    elseif n == "tea" then
        hoverText = "Rootbark tea"
    elseif n == "blend" then
        hoverText = ""
    elseif n == "bowl" then
        hoverText = ""
    elseif n == "pan" then
        hoverText = ""
    elseif n == "enc" then
        hoverText = "Encyclopedia"
    elseif n == "trash" then
        hoverText = "Trash"
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
                if k < 13 then
                    break
                end
            end
        end
    elseif currentScene == SCENES.Credits then
    elseif currentScene == SCENES.Help then
    elseif currentScene == SCENES.Encyclopedia then
        if mx >= 500 and mx <= 750 and my >= 500 and my <= 550 then
            --arrows back and forth
        end
    end

end

function G.mouseReleased(mx, my)

    if currentScene == SCENES.Title then
        --is it on the arrow?
        currentScene = SCENES.Intro
    elseif currentScene == SCENES.Intro then
        --is it on the arrow?
        currentScene = SCENES.Cave
    elseif currentScene == SCENES.Cave then
        if currentlyHeld ~= nil and (currentlyHeld == blenderBottle or currentlyHeld == panPot or currentlyHeld == bowlBag) then
            if mx <= 200 and my <= 230 then
                SubmitProduct()
                return
            end
        end
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
    elseif key == "space" and currentScene <= SCENES.Intro then
        currentScene = currentScene + 1
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
        blenderBottle.ingreds = {}
        bowlBag.ingreds = {}
        panPot.ingreds = {}
    elseif key == "left" then
        if currentScene == SCENES.Encyclopedia and successCount > successThreshold1 then
            if currentEncyclopediaPage > 1 then
                currentEncyclopediaPage = currentEncyclopediaPage - 1
            end
        end
    elseif key == "right" then
        if currentScene == SCENES.Encyclopedia and successCount > successThreshold1 then
            if currentEncyclopediaPage < table.getn(sceneBackgrounds.encyclopedia) then
                currentEncyclopediaPage = currentEncyclopediaPage + 1
            end
        end
    end

end

function G.mouseMoved(mx, my, dx, dy)

    if currentScene == SCENES.Cave then
        for k, v in ipairs(clickTargets) do
            if mx >= v.x and mx <= v.x2 and my >= v.y and my <= v.y2 then
                TakeHoverAction(v.name)
                return
            end
        end
        if mx <= 200 and my <= 230 and (currentlyHeld == blenderBottle or currentlyHeld == panPot or currentlyHeld == bowlBag) then
            hoverText = "give potion to customer"
        else
            hoverText = ""
        end
    else
        hoverText = ""
    end

end

--------------------------
--LOADING IN ASSETS BELOW
--------------------------

function LoadSceneBackgrounds()

    sceneBackgrounds = {
        title = love.graphics.newImage("/assets/title.png"),
        intro = love.graphics.newImage("/assets/intro.png"),
        cave = love.graphics.newImage("/assets/cave.png"),
        --credits = love.graphics.newImage("/assets/credits.png"),
        --help = love.graphics.newImage("/assets/help.png"),
        encyclopedia = {
            love.graphics.newImage("/assets/encyclopedia_2.png"),
            love.graphics.newImage("/assets/encyclopedia_3.png")
        },
        encyclopediaEarly = love.graphics.newImage("/assets/encyclopedia_1.png")
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

    phrases = {
        { --toadstool, FORTITUDE
            "improves my health",
            "increases my overall HP",
            "restores my HP",
            "gives me a fortitude buff",
            "makes me resistant to injury"
        },
        { --lichen, STRENGTH
            "makes me stronger",
            "gives me more lifting power",
            "lets me carry more things",
            "helps me punch harder",
            "helps me use heavier weapons"
        },
        { --glowshroom, INT
            "makes me smarter",
            "improves my mana regeneration",
            "makes my magic skill increase",
            "improves my brain power",
            "jumpstarts my brain"
        },
        { --crystallite, LUCK
            "makes me luckier",
            "helps me to avoid unlucky scenarios",
            "tilts the odds in my favor",
            "helps me in games of chance",
            "increases my odds of success"
        },
        { --fog, AGIL
            "makes me more agile",
            "makes me sneakier",
            "helps me to avoid detection",
            "lets me move more nimbly",
            "helps me to move faster"
        },
        { --stalactite, CHARISMA
            "makes me more charismatic",
            "makes me more likable",
            "makes people more likely to listen to me",
            "makes me more convincing",
            "increases my people skills"
        },
        { --tea, WISDOM
            "makes me wiser",
            "increases my knowledge of the caves",
            "gives me more wisdom",
            "improves my knowledge of plants",
            "improves my knowledge of enemies"
        }
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

    --TODO: position perfectly
    adventurers = {
        A.new(1, "Waldorf", "Wizard", love.graphics.newQuad(0, 0, mult*4, mult*4, adventurerTexture), 0, 30),
        A.new(2, "Hurgle", "Warrior", love.graphics.newQuad(0, mult*4, mult*5, mult*5, adventurerTexture), 0, -48),
        A.new(3, "Sporseesa", "Warlock", love.graphics.newQuad(0, mult*10, mult*3, mult*4, adventurerTexture), 0, 0),
        A.new(4, "Kronkle", "Knight", love.graphics.newQuad(0, mult*14, mult*5, mult*5, adventurerTexture), 0, 0),
        A.new(5, "Jolie", "Mage", love.graphics.newQuad(0, mult*18, mult*4, mult*4, adventurerTexture), 0, 0),
        A.new(6, "Mippie", "Star Fighter", love.graphics.newQuad(0, mult*23, mult*4, mult*4, adventurerTexture), 0, 0),
        A.new(7, "XB-394Q", "Backup", love.graphics.newQuad(0, mult*27, mult*4, mult*5, adventurerTexture), 0, 0),
        A.new(8, "Willow", "Rogue", love.graphics.newQuad(0, mult*32, mult*4, mult*4, adventurerTexture), 0, 0),
        A.new(9, "Gargaro", "Archer", love.graphics.newQuad(0, mult*35, mult*4, mult*3, adventurerTexture), 0, 100),
        A.new(10, "???", "???", love.graphics.newQuad(0, mult*38, mult*4, mult*2, adventurerTexture), 0, 0),
        A.new(11, "King Steve", "Supervisor", love.graphics.newQuad(0, mult*41, mult*4, mult*4, adventurerTexture), 0, 0)
    }

end

function LoadSFX()

end

function LoadMiscAssets()

    toolsTexture = love.graphics.newImage("/assets/tools.png")
    local mult = 64

    finishedTexture = love.graphics.newImage("/assets/finished.png")

    miscAssets = {
        counter = love.graphics.newImage("/assets/counter.png"),
        speechBubble = love.graphics.newImage("/assets/bubble.png"),
        bowlFront = love.graphics.newQuad(mult*3, mult*3, mult*3, mult*2, toolsTexture),
        bowlBack = love.graphics.newQuad(0, mult*3, mult*3, mult, toolsTexture),
        blenderFront = love.graphics.newQuad(mult*2, 0, mult*2, mult*3, toolsTexture),
        blenderBack = love.graphics.newQuad(0, 0, mult*2, mult*3, toolsTexture),
        pan = love.graphics.newQuad(0, mult*5, mult*5, mult*2, toolsTexture),
        enc = love.graphics.newImage("/assets/enc-sm.png"),
        trash = love.graphics.newImage("/assets/trash.png"),
        blenderBottle = love.graphics.newQuad(0, 0, 96, 96, finishedTexture),
        bowlBag = love.graphics.newQuad(0, 96, 96, 96, finishedTexture),
        panPot = love.graphics.newQuad(0, 192, 96, 96, finishedTexture)
    }

    blenderBottle = {
        id = 100,
        ingreds = {},
        quad = miscAssets.blenderBottle,
        offsetX = 24,
        offsetY = 50,
        x = 220,
        y = 180
    }
    bowlBag = {
        id = 200,
        ingreds = {},
        quad = miscAssets.bowlBag,
        offsetX = 30,
        offsetY = 30,
        x = 220,
        y = 180
    }
    panPot = {
        id = 300,
        ingreds = {},
        quad = miscAssets.panPot,
        offsetX = 20,
        offsetY = 20,
        x = 220,
        y = 180
    }

    textFontLg = love.graphics.newFont("/assets/Macondo-Regular.ttf", 24)
    textFontMd = love.graphics.newFont("/assets/Macondo-Regular.ttf", 20)
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

    table.insert(clickTargets, {
        name = "bottle",
        x = blenderBottle.x,
        y = blenderBottle.y,
        x2 = blenderBottle.x + 96,
        y2 = blenderBottle.y + 96 })

    table.insert(clickTargets, {
        name = "bag",
        x = bowlBag.x,
        y = bowlBag.y,
        x2 = bowlBag.x + 96,
        y2 = bowlBag.y + 96 })

    table.insert(clickTargets, {
        name = "pot",
        x = panPot.x,
        y = panPot.y,
        x2 = panPot.x + 96,
        y2 = panPot.y + 96 })

end

return G