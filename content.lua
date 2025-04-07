C = {}

function C.getIngredientDescription(id)

    if id == 1 then --pink toadstool
        return ""
    elseif id == 2 then --cave lichen
        return ""
    elseif id == 3 then --glowshroom
        return ""
    elseif id == 4 then --crystallite
        return ""
    elseif id == 5 then --essense of fog
        return ""
    elseif id == 6 then --stalactite drops
        return ""
    elseif id == 7 then --rootbark tea
        return ""
    end

end


function C.fillInRecipeBlanks(recipe)

    local id = recipe.id

    if id == 1 then 
        recipe.name = "Salad Sanitas"
        recipe.description = ""
        recipe.ingredients = "11"
        recipe.method = 1
    elseif id == 2 then 
        recipe.name = "Salad Potentia"
        recipe.description = ""
        recipe.ingredients = "12"
        recipe.method = 1
    elseif id == 3 then 
        recipe.name = "Magna Mix"
        recipe.description = ""
        recipe.ingredients = "14"
        recipe.method = 1
    elseif id == 4 then 
        recipe.name = "Salad Potis"
        recipe.description = ""
        recipe.ingredients = "22"
        recipe.method = 1
    elseif id == 5 then 
        recipe.name = "Salad Summus"
        recipe.description = ""
        recipe.ingredients = "24"
        recipe.method = 1
    elseif id == 6 then 
        recipe.name = "Dicax Medley"
        recipe.description = ""
        recipe.ingredients = "33"
        recipe.method = 1
    elseif id == 7 then 
        recipe.name = "Notio Mix"
        recipe.description = ""
        recipe.ingredients = "34"
        recipe.method = 1
    elseif id == 8 then 
        recipe.name = "Salad Trifolium"
        recipe.description = ""
        recipe.ingredients = "44"
        recipe.method = 1
    elseif id == 9 then 
        recipe.name = "Potion Vita"
        recipe.description = ""
        recipe.ingredients = "11"
        recipe.method = 2
    elseif id == 10 then
        recipe.name = "Potion Vivax"
        recipe.description = ""
        recipe.ingredients = "12"
        recipe.method = 2
    elseif id == 11 then
        recipe.name = "Vivamagus Brew"
        recipe.description = ""
        recipe.ingredients = "13"
        recipe.method = 2
    elseif id == 12 then
        recipe.name = "Faustus Elixir"
        recipe.description = ""
        recipe.ingredients = "14"
        recipe.method = 2
    elseif id == 13 then
        recipe.name = "Lightfoot Philtre"
        recipe.description = ""
        recipe.ingredients = "15"
        recipe.method = 2
    elseif id == 14 then
        recipe.name = "Potion Rapidus"
        recipe.description = ""
        recipe.ingredients = "16"
        recipe.method = 2
    elseif id == 15 then
        recipe.name = "Philtre Fortis"
        recipe.description = ""
        recipe.ingredients = "22"
        recipe.method = 2
    elseif id == 16 then
        recipe.name = "Benemax Brew"
        recipe.description = ""
        recipe.ingredients = "23"
        recipe.method = 2
    elseif id == 17 then
        recipe.name = "str + luck"
        recipe.description = ""
        recipe.ingredients = "24"
        recipe.method = 2
    elseif id == 18 then
        recipe.name = "Bumblebee Mix"
        recipe.description = ""
        recipe.ingredients = "25"
        recipe.method = 2
    elseif id == 19 then
        recipe.name = "Muscle Salad"
        recipe.description = ""
        recipe.ingredients = "26"
        recipe.method = 2
    elseif id == 20 then
        recipe.name = "int + int"
        recipe.description = ""
        recipe.ingredients = "33"
        recipe.method = 2
    elseif id == 21 then
        recipe.name = "int + luck"
        recipe.description = ""
        recipe.ingredients = "34"
        recipe.method = 2
    elseif id == 22 then
        recipe.name = "Leapfrog Salad"
        recipe.description = ""
        recipe.ingredients = "35"
        recipe.method = 2
    elseif id == 23 then
        recipe.name = "Brains + Beauty Medley"
        recipe.description = ""
        recipe.ingredients = "36"
        recipe.method = 2
    elseif id == 24 then
        recipe.name = "Mage Mix"
        recipe.description = ""
        recipe.ingredients = "37"
        recipe.method = 2
    elseif id == 25 then
        recipe.name = "luck + luck"
        recipe.description = ""
        recipe.ingredients = "44"
        recipe.method = 2
    elseif id == 26 then
        recipe.name = "Sneaky Salad"
        recipe.description = ""
        recipe.ingredients = "45"
        recipe.method = 2
    elseif id == 27 then
        recipe.name = "Convincing Mix"
        recipe.description = ""
        recipe.ingredients = "46"
        recipe.method = 2
    elseif id == 28 then
        recipe.name = "Aha! Medley"
        recipe.description = ""
        recipe.ingredients = "47"
        recipe.method = 2
    elseif id == 29 then
        recipe.name = "fort + fort"
        recipe.description = ""
        recipe.ingredients = "11"
        recipe.method = 3
    elseif id == 30 then
        recipe.name = "fort +. str"
        recipe.description = ""
        recipe.ingredients = "12"
        recipe.method = 3
    elseif id == 31 then
        recipe.name = "fort + int"
        recipe.description = ""
        recipe.ingredients = "13"
        recipe.method = 3
    elseif id == 32 then
        recipe.name = "fort + luck"
        recipe.description = ""
        recipe.ingredients = "14"
        recipe.method = 3
    elseif id == 33 then
        recipe.name = "fort + agil"
        recipe.description = ""
        recipe.ingredients = "15"
        recipe.method = 3
    elseif id == 34 then
        recipe.name = "fort + char"
        recipe.description = ""
        recipe.ingredients = "16"
        recipe.method = 3
    elseif id == 35 then
        recipe.name = "fort + wis"
        recipe.description = ""
        recipe.ingredients = "17"
        recipe.method = 3
    elseif id == 36 then
        recipe.name = "str"
        recipe.description = ""
        recipe.ingredients = "22"
        recipe.method = 3
    elseif id == 37 then
        recipe.name = "str + int"
        recipe.description = ""
        recipe.ingredients = "23"
        recipe.method = 3
    elseif id == 38 then
        recipe.name = "str + luck"
        recipe.description = ""
        recipe.ingredients = "24"
        recipe.method = 3
    elseif id == 39 then
        recipe.name = "str + agi"
        recipe.description = ""
        recipe.ingredients = "25"
        recipe.method = 3
    elseif id == 40 then
        recipe.name = "str + char"
        recipe.description = ""
        recipe.ingredients = "26"
        recipe.method = 3
    elseif id == 41 then
        recipe.name = "str + wis"
        recipe.description = ""
        recipe.ingredients = "27"
        recipe.method = 3
    elseif id == 42 then
        recipe.name = "int + int"
        recipe.description = ""
        recipe.ingredients = "33"
        recipe.method = 3
    elseif id == 43 then
        recipe.name = "int + luck"
        recipe.description = ""
        recipe.ingredients = "34"
        recipe.method = 3
    elseif id == 44 then
        recipe.name = "int + agi"
        recipe.description = ""
        recipe.ingredients = "35"
        recipe.method = 3
    elseif id == 45 then
        recipe.name = "int + char"
        recipe.description = ""
        recipe.ingredients = "36"
        recipe.method = 3
    elseif id == 46 then
        recipe.name = "int + wis"
        recipe.description = ""
        recipe.ingredients = "37"
        recipe.method = 3
    elseif id == 47 then
        recipe.name = "luck + luck"
        recipe.description = ""
        recipe.ingredients = "44"
        recipe.method = 3
    elseif id == 48 then
        recipe.name = "luck + agi"
        recipe.description = ""
        recipe.ingredients = "45"
        recipe.method = 3
    elseif id == 49 then
        recipe.name = "luck + char"
        recipe.description = ""
        recipe.ingredients = "46"
        recipe.method = 3
    elseif id == 50 then
        recipe.name = "luck + wis"
        recipe.description = ""
        recipe.ingredients = "47"
        recipe.method = 3  
    end

    return recipe

end

function C.getDialog(id)

    if id == 1 then --waldorf the wizard
        return {
            first = "Salutations! It is I, the wizard Waldorf!",
            lostStats = "Verily, I am troubled by our last transaction.",
            keptStats = "Huzzah! Your last concoction proved successful!",
            flavor = {
                "The trials before me are immense.",
                "My tribulations grow ever more dangerous.",
                "I have heretofore been on the proverbial Easy Street.",
                "The challenges I face are innumerable and befit a far more advanced wizard.",
                "It is through your skill and mine that I have triumphed up to now."
            },
            recipeIds = {
                13, 23, 25, 27, 47
            },
            requestStart = "Would you assist me in my quest with",
            requestEnd = "Many thanks."
        }
    elseif id == 2 then --hurgle the warrior
        return {
            first = "HALLOOO! Hurgle me, famous warrior.",
            lostStats = "Hurgle last hurt bad cantina but you only cantina in cave.",
            keptStats = "Hurgle do good fights at bad guys with thanks to you.",
            flavor = {
                "Next fight so small Hurgle could do it no eyes.",
                "Caves so easy ahead that baby Hurgle could do fight.",
                "Fights a little bit hard in next cave if Hurgle say truth.",
                "Hurgle need the best stuff in the whole caves.",
                "This as far as Hurgle made! One fight left!"
            },
            recipeIds = {
                2, 4, 14, 30, 41
            },
            requestStart = "Hurgle fight need",
            requestEnd = "Good thank."
        } 
    elseif id == 3 then --sporseesa the warlock
        return {
            first = "Sssalutations, ssstore proprietor. I am Sssporseesa, warlock.",
            lostStats = "Ssseething with rage at lassst visssit.",
            keptStats = "Ssseveral thanksss to your assssisssstance.",
            flavor = {
                "Ssslippery cavesss ssseek to sssubsssume Sssporseesa.",
                "Ssseveral sssalamanders ssscouted ahead by Ssporseesa.",
                "Ssskirmishes ahead requessst sssubsequent sssolutions.",
                "Ssstruggles ahead even more ssstrenuous. Ssseeking sssolutions!",
                "Endmossst ssskirmish ahead."
            },
            recipeIds = {
                9, 29, 35, 38, 42
            },
            requestStart = "Pleassse sssupply Sssporseesa with",
            requestEnd = "Thanksss."
        } 
    elseif id == 4 then --kronkle the knight
        return {
            first = "Greetings. I am Sir Kronkle, cave knight!",
            lostStats = "Thine mixture *unintelligible* bad time.",
            keptStats = "His royal highness *unintelliglble* thanks.",
            flavor = {
                "Tis hard to speak in full armor yet harder still to *unintelligible.*",
                "These caves have *unintelligible* quite rusty.",
                "Cave knights need more training *unintelligible* sentient mushrooms.",
                "His majesty might have warned *unintelligible* through this helmet.",
                "The final challenge awaits! Wish *unintelligible*."
            },
            recipeIds = {
                1, 7, 10, 17, 36
            },
            requestStart = "Strewth! His majesty requests you supply me with",
            requestEnd = "Regards."
        } 
    elseif id == 5 then --jolie the mage
        return {
            first = "Oh my word, I finally found the Cantina! I'm Jolie, mage.",
            lostStats = "I'm not so sure our last transaction went well for me.",
            keptStats = "I delight in your ability to assist me in my adventures!",
            flavor = {
                "A mage is only as good as her supporting substances.",
                "The caves ahead are dark and full of monsters.",
                "Nobody ever says how much gunk is down here. A lot.",
                "Mages are extra good at caving because... we have you to help!",
                "I think I almost finished exploring this cave!"
            },
            recipeIds = {
                6, 8, 11, 20, 24
            },
            requestStart = "So would you be so kind as to provide me with",
            requestEnd = "Thank you!"
        } 
    elseif id == 6 then --mippie the star fighter
        return {
            first = "hiiii i'm mippie and i'm a STAR FIGHTER!!!",
            lostStats = "i dont kno wat u gave me last time but it didnt help me.",
            keptStats = "wowwweeee the last stuff u gave was so good! X_X",
            flavor = {
                "ok so its my first time in the caves so i need ur help.",
                "i got bigger problems now and i need more of your good stuff!",
                "it would b so dark in the caves if i wasnt my own flashlight!!",
                "how did i get this far, my stardad is gonna be so stoked at me!",
                "ok its my last fight before i go back to the sky!!!"
            },
            recipeIds = {
                12, 21, 31, 34, 45
            },
            requestStart = "so i reeeeally need",
            requestEnd = "thank uuuu!! O_O"
        } 
    elseif id == 7 then -- robot, backup
        return {
            first = "Tch...zzt... entity XB-394Q.",
            lostStats = "Previous mission status: ..bzzt.. failure.",
            keptStats = "Previous mission status: ..kachunk.. success.",
            flavor = {
                "Mission details: assist caver with multiple unnamed aggressors.",
                "Mission details: ..bzzt..clickclick...whirrrrr..WOOOEEEOOOEEOOO.",
                "Mission details: locate very expensive chip lost with previous model.",
                "Mission details: seek princess for assistance in rescue attempt.",
                "Mission details: complete final tasks before decommission."
            },
            recipeIds = {
                16, 22, 39, 43, 48
            },
            requestStart = "...TCH-CH... Requested materials:",
            requestEnd = "Assistance noted."
        } 
    elseif id == 8 then --willow, rogue
        return {
            first = "I suppose you thought I would bark, or some such? I am Willow, the rogue.",
            lostStats = "Just because I am a canine does not mean you can swindle me.",
            keptStats = "That last mixture was so good it almost made me BARK! Ahem.",
            flavor = {
                "I delight in exploring and sniffing various cave flora.",
                "Are you even aware, kind proprietor, how many objects are here that I can pee on?",
                "I suppose others who visit are here to fight. Not I! But so many smells.",
                "To tell you truth, I'm really only visiting because I like your food and drink.",
                "This may be my last visit to your esteemed Cantina."
            },
            recipeIds = {
                26, 28, 33, 40, 44
            },
            requestStart = "Would you please provide me with",
            requestEnd = "Grrrrreat!"
        } 
    elseif id == 9 then --gargaro, archer
        return {
            first = "Ahem. Down here! I am Gargaro, adept with a bow.",
            lostStats = "The last stuff you sold me was not fit for a goblin of ANY stature!",
            keptStats = "I feel invigorated by our last transaction!",
            flavor = {
                "Nobody told me how tough it'd be to shoot arrows in the dark.",
                "I hear that someone up ahead is selling arros that shoot around corners!",
                "The arrows-around-corners thing didn't pan out. Physics or something.",
                "The cave ahead is really big - perfect for my arrows!",
                "The next cave will be my last!"
            },
            recipeIds = {
                3, 5, 18, 49, 50
            },
            requestStart = "I need a bit of help with",
            requestEnd = "A grand thanks to you."
        } 
    elseif id == 10 then --??? ???
        return {
            first = "You have done well thus far, helping those who would explore these caves. Please take these extracts and this blender to provide further assistance.",
            second = "You are well established as a resource for cavers. Please take this pan to produce even more help for the cavers."
        } 
    elseif id == 11 then --king steve, supervisor
        return {
            first = "Heya, bud! I'm Steve. I keep an eye on adventurers around here.",
            lostStats = "Look, I don't know what you gave me last time, but... ugh.",
            keptStats = "You are an absolute magician, dude(tte)! Way to work that cantina!",
            flavor = {
                "I think I see some danger up ahead.",
                "I didn't make it that far yet but I will keep! Going!",
                "I can feel it, this time is gonna be the coolest fight yet!",
                "I know I already said this but THIS ONE will be the COOLEST.",
                "It's the last fight now so it better be COOL."
            },
            recipeIds = {
                15, 19, 32, 37, 46
            },
            requestStart = "Help a dude out with",
            requestEnd = "You're welcome. I mean, thank you."
        } 
    end

end

return C