-- not a real battle, but has part of a battle.
-- battles in undertale have your sould (the heart) moving around the screen dodging attacks.
-- since this is the very first "battle", you can't do any attacks, just see the dialogue and dodge them.
__timer = 0
local function wait(t)
    -- pause the whole game for t seconds.
    os.execute("sleep " .. tonumber(t))
end
function bs.flowey.beginning.load()
    battle = {}

    fnt_curs = love.graphics.newFont('fnt_curs.ttf', 28)
    battle.box = {
        x=95,y=10,
        w=125,h=125,

        draw = function()
            love.graphics.setColor(0,0,0,1)
            love.graphics.rectangle('fill', battle.box.x, battle.box.y, battle.box.w, battle.box.h)
            love.graphics.setColor(1,1,1,1)
            love.graphics.rectangle('line', battle.box.x+3, battle.box.y+3, battle.box.w-6, battle.box.h-6)
        end,
    }

    battle.laugh = love.audio.newSource("flowey/snd_floweylaugh.wav", "static")
    battle.laugh:setLooping(true)
    battle.laugh:setVolume(0.5)

    battle.hurt = love.audio.newSource("snd_hurt1.wav", "static")

    battle.spawnin = love.audio.newSource("snd_chug.wav", "static")

    battle.heal = love.audio.newSource("snd_heal_c.wav", "static")

    battle.soul = {
        spr = {
            [0] = love.graphics.newImage("soul/0.png") -- red heart
        },
        -- center of the box
        x=152,y=66,
        w=16,h=16,
        hsp=0,vsp=0,
        spd=1,

        doCollision = function()
            local box = {x1=battle.box.x,y1=battle.box.y,x2=battle.box.x+battle.box.w,y2=battle.box.y+battle.box.h}
            local x1 = battle.soul.x + battle.soul.hsp
            local y1 = battle.soul.y + battle.soul.vsp

            if x1 > box.x2-20 then battle.soul.hsp = 0 end
            if x1 < box.x1+5 then battle.soul.hsp = 0 end
            if y1 > box.y2-20 then battle.soul.vsp = 0 end
            if y1 < box.y1+5 then battle.soul.vsp = 0 end
        end,
    }

    lastX, lastY = battle.soul.x, battle.soul.y

    battle.attackCache = {}

    flameX = 300
    torielX = 300

    battle.health = 20

    battle.enemy = {
        x=150,y=120,
        body = {
            ["normal"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/nice/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/nice/1.png"),
            },
            ["laugh"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/laugh/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/laugh/1.png"),
            },
            ["evil"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/evil/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/evil/1.png"),
            },
            ["normal"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/nice/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/nice/1.png"),
            },
            ["laugh"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/laugh/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/laugh/1.png"),
            },
            ["evil"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/evil/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/evil/1.png"),
            },
            ["grin"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/grin/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/grin/1.png"),
            },
            ["right"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/right/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/right/1.png"),
            },
            ["rightglare"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/rightglare/0.png"),
                [1] = love.graphics.newImage("npc/flowey/dialogue/rightglare/1.png"),
            },
            ["wink"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/wink/0.png")
            },
            ["hurt"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/hurt/0.png")
            },
            ["shock"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/shock/0.png")
            },
            ["pissed"] = {
                [0] = love.graphics.newImage("npc/flowey/dialogue/pissed/0.png")
            }
        },
        frame = 0,

        dialogues = {
            spr = {
                [0] = love.graphics.newImage("dialogue/bubble_left0.png")
            },
            showDialogue = true,
            showBox = true,
            curDialogue = "",
            curText = "",
            curCharacter = 0,
            lines = {
                [0] = {
                    "See that heart?{wait=0.2}\nThat is your SOUL,{wait=0.2}\nthe very culmination\nof your being!",
                    "Your SOUL starts off\nweak,{wait=0.2} but can grow strong\nif you gain\na lot of LV.",
                    "What's LV stand for?{wait=0.2}\nWhy, LOVE, of course!",
                    "You want some\nLOVE, don't you?",
                    "Don't worry,\nI'll share some with you!",
                    "{animation=wink,time=1.35}", -- wink animation, 2 seconds don't show dialogue
                    "{setup_attack=pellets,skip}", -- skip this and go to next line, setup attack "pellets"
                    "{main_animation=right}Down here, LOVE is\nshared through...",
                    "Little white...\n{main_animation=rightglare,time=0.5}\"friendliness pellets.\"",
                    "{main_animation=normal}Are you ready?",
                    "{movestuff=true}Move around!{wait=0.2}\nGet as many as\nyou can!",
                },
                [1] = {
                    "{shaky=true}You idiot.",
                    "{shaky=true}In this world, it's\nkill or BE killed.",
                    "{shaky=true}Why would ANYONE pass\nup an opportunity\nlike this!?",
                    "{setup_attack=pelletcircle,time=3,skip,main_animation=evil}",
                    "{large=true}Die.",
                    "{movein=true,skip}"
                },
                [2] = {

                }
            },
            curLine = 1,
            timer = 0,
            waitTimer = 0,
            waitTime = 0,
            cur_animation = "normal",
            main_animation = "normal",
            timeTimer = 0,
            curDialogueLines = 0,
            finished = false,
            shakeyText = false,
            largeText = false,

            blip = love.audio.newSource("dialogue/flowey/0.wav", "static"),

            updateDialogue = function(gt, ss)
                if battle.enemy.dialogues.showDialogue then
                    if battle.enemy.dialogues.waitTimer > 0 then
                        battle.enemy.dialogues.waitTimer = battle.enemy.dialogues.waitTimer - gt
                    else
                        if battle.enemy.dialogues.timer > 0 then
                            battle.enemy.dialogues.timer = battle.enemy.dialogues.timer - gt
                        else
                            if battle.enemy.dialogues.curLine > #battle.enemy.dialogues.lines[battle.enemy.dialogues.curDialogueLines] then
                                battle.enemy.dialogues.showDialogue = false
                                battle.state = "move"
                            else
                                line = battle.enemy.dialogues.lines[battle.enemy.dialogues.curDialogueLines][battle.enemy.dialogues.curLine]
                                if battle.enemy.dialogues.timer <= 0 and battle.enemy.dialogues.waitTimer <= 0 and ss then
                                    battle.enemy.dialogues.timer = 0.05
                                    battle.enemy.dialogues.curText = battle.enemy.dialogues.curText .. line:sub(battle.enemy.dialogues.curCharacter, battle.enemy.dialogues.curCharacter)
                                    battle.enemy.dialogues.curCharacter = battle.enemy.dialogues.curCharacter + 1
                                    -- every 2 characters, play battle.enemy.dialogues.blip but not when its done
                                    if battle.enemy.dialogues.curCharacter % 2 == 0 and battle.enemy.dialogues.curCharacter < #line then
                                        battle.enemy.dialogues.blip:stop()
                                        battle.enemy.dialogues.blip:play()
                                    end
                                    -- ever 4, change battle.enemy.frame by 1, if its larger than the amount of frames, set it to 0
                                    if battle.enemy.dialogues.curCharacter % 4 == 0 and battle.enemy.dialogues.curCharacter < #line then
                                        battle.enemy.frame = battle.enemy.frame + 1
                                        if battle.enemy.frame > #battle.enemy.body[battle.enemy.dialogues.cur_animation] then
                                            battle.enemy.frame = 0
                                        end
                                    else
                                        battle.enemy.frame = 0
                                    end
                                else
                                    battle.enemy.dialogues.waitTimer = battle.enemy.dialogues.waitTimer - gt
                                end
                                if line:sub(battle.enemy.dialogues.curCharacter, battle.enemy.dialogues.curCharacter) == "{" then
                                    -- find the next "}"
                                    local nextBracket = line:find("}", battle.enemy.dialogues.curCharacter)
                                    local cmd = line:sub(battle.enemy.dialogues.curCharacter+1, nextBracket-1)
                                    print(cmd)
                                    -- remove the command from the line
                                    if cmd:find("wait") then
                                        local cmd = cmd:split("=")
                                        if cmd[1] == "wait" then
                                            battle.enemy.dialogues.waitTimer = tonumber(cmd[2])
                                        end
                                        if cmd[1] == "main_animation" then
                                            battle.enemy.dialogues.main_animation = cmd[2]
                                        end

                                        -- remove the command from the line
                                        line = line:sub(0, battle.enemy.dialogues.curCharacter-1) .. line:sub(nextBracket+1, #line)
                                        battle.enemy.dialogues.lines[battle.enemy.dialogues.curDialogueLines][battle.enemy.dialogues.curLine] = line
                                    else
                                        local nextBracket = line:find("}", battle.enemy.dialogues.curCharacter)
                                        local cmd = line:sub(battle.enemy.dialogues.curCharacter+1, nextBracket-1)
                                        -- remove the command from the line
                                        line = line:sub(0, battle.enemy.dialogues.curCharacter-1) .. line:sub(nextBracket+1, #line)
                                        battle.enemy.dialogues.lines[battle.enemy.dialogues.curDialogueLines][battle.enemy.dialogues.curLine] = line
                                        if cmd:find(",") then
                                            -- split by ,
                                            local args = {}
                                            for arg in cmd:gmatch("[^,]+") do
                                                table.insert(args, arg)
                                            end
                                            for i=1,#args do
                                                local arg = args[i]
                                                --print(arg)
                                                if arg:find("=") then
                                                    local argName = arg:match("(.-)=")
                                                    local argValue = arg:match("=(.+)")
                                                    print(argName, argValue)
                                                    if argName == "main_animation" then

                                                        battle.enemy.dialogues.main_animation = argValue
                                                    elseif argName == "animation" then
                                                        battle.enemy.dialogues.timer = 0.05
                                                        battle.enemy.dialogues.curDialogue = ""
                                                        battle.enemy.dialogues.cur_animation = argValue
                                                        battle.enemy.dialogues.showBox = false
                                                    elseif argName == "time" then
                                                        battle.enemy.dialogues.timeTimer = tonumber(argValue)
                                                        battle.enemy.showDialogue = false
                                                    elseif argName == "setup_attack" then
                                                        battle.enemy.attacks[argValue].attack()
                                                        print("setup attack " .. argValue)
                                                    elseif argName == "skip" then
                                                        battle.enemy.dialogues.changeDialogue()
                                                    elseif argName == "movestuff" then
                                                        battle.enemy.attacks.pellets.movestuff = true
                                                        lastX, lastY = battle.soul.x, battle.soul.y
                                                    elseif argName == "shakey" then
                                                        battle.enemy.dialogues.shakeyText = true
                                                        battle.enemy.dialogues.chars = {}
                                                        local newLines = {}
                                                        -- get newline count
                                                        local newlineCount = 0
                                                        local charterIndex = 0
                                                        for i=1,#battle.enemy.dialogues.curText do
                                                            if battle.enemy.dialogues.curText:sub(i,i) == "\n" then
                                                                newlineCount = newlineCount + 1
                                                                charterIndex = i

                                                                table.insert(newLines, {"\n", index=charterIndex})
                                                            end
                                                        end
                                                        local allNewlines = ""
                                                        for i=1,#battle.enemy.dialogues.curText do
                                                            local curIndex = i
                                                            local newlines = ""
                                                            -- check if there is a newline
                                                            for j=1,#newLines do
                                                                if newLines[j].index == curIndex then
                                                                    newlines = newlines .. "\n"
                                                                end
                                                            end
                                                            local char = battle.enemy.dialogues.curText:sub(i,i)
                                                            local str = newlines .. char
                                                            table.insert(battle.enemy.dialogues.chars, {char = str, shakey = math.random(-2,2), shakex = math.random(-2,2)})
                                                        end
                                                    elseif argName == "large" then
                                                        battle.enemy.dialogues.largeText = true
                                                    elseif argName == "movein" then
                                                        battle.enemy.attacks.pelletcircle.movein = true
                                                        battle.enemy.dialogues.main_animation = "laugh"
                                                        battle.laugh:play()
                                                    end
                                                end
                                            end
                                        else
                                            if cmd:find("=") then
                                                local argName = cmd:match("(.-)=")
                                                local argValue = cmd:match("=(.+)")
                                                print(argName .. " " .. argValue)
                                                if argName == "main_animation" then
                                                    battle.enemy.dialogues.main_animation = argValue
                                                    --print(battle.enemy.dialogues.main_animation)
                                                elseif argName == "animation" then
                                                    battle.enemy.dialogues.cur_animation = argValue
                                                    battle.enemy.dialogues.showBox = false
                                                elseif argName == "time" then
                                                    battle.enemy.dialogues.timeTimer = tonumber(argValue)
                                                elseif argName == "setup_attack" then
                                                    battle.enemy.attacks[argValue].attack()
                                                    print("setup attack " .. argValue)
                                                elseif argName == "skip" then
                                                    battle.enemy.dialogues.changeDialogue()
                                                elseif argName == "movestuff" then
                                                    battle.enemy.attacks.pellets.movestuff = true
                                                    lastX, lastY = battle.soul.x, battle.soul.y
                                                elseif argName == "shakey" then
                                                    battle.enemy.dialogues.shakeyText = true
                                                    battle.enemy.dialogues.chars = {}
                                                    local newLines = {}
                                                    -- get newline count
                                                    local newlineCount = 0
                                                    local charterIndex = 0
                                                    for i=1,#battle.enemy.dialogues.curText do
                                                        if battle.enemy.dialogues.curText:sub(i,i) == "\n" then
                                                            newlineCount = newlineCount + 1
                                                            charterIndex = i

                                                            table.insert(newLines, {"\n", index=charterIndex})
                                                        end
                                                    end
                                                    local allNewlines = ""
                                                    for i=1,#battle.enemy.dialogues.curText do
                                                        local curIndex = i
                                                        local newlines = ""
                                                        -- check if there is a newline
                                                        for j=1,#newLines do
                                                            if newLines[j].index == curIndex then
                                                                newlines = newlines .. "\n"
                                                            end
                                                        end
                                                        local char = battle.enemy.dialogues.curText:sub(i,i)
                                                        local str = newlines .. char
                                                        table.insert(battle.enemy.dialogues.chars, {char = str, shakey = math.random(-2,2), shakex = math.random(-2,2)})
                                                    end
                                                elseif argName == "large" then
                                                    battle.enemy.dialogues.largeText = true
                                                elseif argName == "movein" then
                                                    battle.enemy.dialogues.moveIn = true
                                                    battle.laugh:play()
                                                    battle.enemy.dialogues.showBox = false
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- count timers
                if battle.enemy.dialogues.timeTimer > 0 then
                    battle.enemy.dialogues.timeTimer = battle.enemy.dialogues.timeTimer - gt
                else
                    battle.enemy.dialogues.timeTimer = 0
                    if battle.enemy.dialogues.cur_animation ~= battle.enemy.dialogues.main_animation then
                        battle.enemy.dialogues.cur_animation = battle.enemy.dialogues.main_animation
                        battle.enemy.frame = 0
                    end                    
                end

                if battle.enemy.dialogues.timer > 0 then
                    battle.enemy.dialogues.timer = battle.enemy.dialogues.timer - gt
                else
                    battle.enemy.dialogues.timer = 0
                    battle.enemy.dialogues.showDialogue = true
                end
            end,

            drawDialogue = function()
                if battle.enemy.dialogues.showDialogue and battle.enemy.dialogues.showBox then
                    love.graphics.draw(battle.enemy.dialogues.spr[0], 235, 120, 0, 0.7, 0.7)
                    love.graphics.setColor(0,0,0)
                    if not battle.enemy.dialogues.shakeyText then
                        love.graphics.printf(battle.enemy.dialogues.curText, 260, 125, 200, "left", 0, (battle.enemy.dialogues.largeText and 4 or 1), (battle.enemy.dialogues.largeText and 4 or 1))
                    else
                        -- instead, prints each character individually, with a random offset that changes
                       --[[  for i=1,#battle.enemy.dialogues.chars do
                            local char = battle.enemy.dialogues.chars[i]
                            -- update shakey and shakex
                            char.shakey = math.random(-2,2)
                            char.shakex = math.random(-2,2)
                            love.graphics.printf(char.char, 260 + char.shakex, 125 + char.shakey, 200, "left")
                        end ]]
                        love.graphics.printf(battle.enemy.dialogues.curText, 260, 125, 200, "left", 0, (battle.enemy.dialogues.largeText and 4 or 1), (battle.enemy.dialogues.largeText and 4 or 1))
                    end
                    if battle.enemy.dialogues.timeTimer < 0.0001 then
                        battle.enemy.dialogues.cur_animation = battle.enemy.dialogues.main_animation
                    end
                end
            end,

            changeDialogue = function()
                battle.enemy.dialogues.curLine = battle.enemy.dialogues.curLine + 1
                battle.enemy.dialogues.curDialogue = ""
                battle.enemy.dialogues.curText = ""
                battle.enemy.dialogues.timer = 0.05
                battle.enemy.dialogues.curCharacter = 0
                battle.enemy.dialogues.largeText = false
                battle.enemy.dialogues.shakeyText = false
                battle.enemy.dialogues.showBox = true
            end
        },

        attacks = {
            pellets = {
                -- creates 5 pellets, moves away from enemy.xy at an angle (like a half circle) from the top left to the top right
                -- then moves to the players last position

                -- the pellets are ovals, they always rotate by 90 degrees every 2 frames

                attack = function()
                    battle.attackCache.pellets = {}
                    battle.attackCache.pellets.objs = {}
                    
                    -- create the pellets
                    for i=1,5 do
                        local obj = {
                            x = battle.enemy.x,
                            y = battle.enemy.y,
                            w = 2,
                            h = 8,
                            angle = 0,
                            spd = 5,
                            rot = 0,
                            rotSpd = 90,
                            rotTimer = 0.05,
                            rotDir = 1,
                            rotMax = 90,
                            rotMin = 0,
                            moveAngle = -((i-1) * 45 - (45/2)), -- ignore this blehhhhh

                            drawSeperate = battle.enemy.attacks.pellets.drawSeperate,

                            update = battle.enemy.attacks.pellets.update,
                            draw = battle.enemy.attacks.pellets.draw,
                            hit = battle.enemy.attacks.pellets.hit,
                        }
                        table.insert(battle.attackCache.pellets.objs, obj)
                        --print(#battle.attackCache.pellets.objs)
                    end
                end,

                movestuff = false, -- just for flowey cutscene

                update = function(gt, i)
                    curGameTime = math.floor(love.timer.getTime())
                    if battle.attackCache.pellets == nil then return end
                    for i = 1, #battle.attackCache.pellets.objs do
                        local obj = battle.attackCache.pellets.objs[i]
                        if not obj then return end
                        __timer = __timer + 1
                        if __timer % 2 == 0 then -- second frame
                            obj.angle = obj.angle + math.rad(90)
                            __timer = 0
                        end
                        -- slowly move to player increasing in speed
                        if battle.enemy.attacks.pellets.movestuff then
                            obj.spd = obj.spd + 1 * gt

                            -- move to player
                            local distanceX = lastX-35 - obj.x
                            local distanceY = lastY+275 - obj.y
                            if not obj.determinedAngle then
                                obj.determinedAngle = math.atan2(distanceY, distanceX)
                            end
                            obj.x = obj.x + math.cos(obj.determinedAngle) * (obj.spd * 25) * gt
                            obj.y = obj.y + math.sin(obj.determinedAngle) * (obj.spd * 25) * gt
                            -- move obj.y another 400 px down

                            if obj.y > 480 then
                                table.remove(battle.attackCache.pellets.objs, i)
                            end
                        else
                            -- slowly move away from enemy until atleast 50 pixels away
                            local px, py = battle.enemy.x, battle.enemy.y
                            local dx, dy = px - obj.x, py - obj.y
                            local angle = obj.moveAngle
                            if math.sqrt(dx*dx + dy*dy) < 50 then
                                obj.x = obj.x - math.cos(angle) * (obj.spd * 25) * gt
                                obj.y = obj.y - math.sin(angle) * (obj.spd * 25) * gt
                            else
                                obj.spd = 0.08
                            end
                        end 
                    end
                end,

                isCollision = function(i)
                    -- checks if pellet is in contact with soul
                    if battle.attackCache.pellets == nil then return end
                    for i=1,#battle.attackCache.pellets.objs do
                        local obj = battle.attackCache.pellets.objs[i]
                        if not obj then return end
                        if obj then
                            -- since after 240y, we subtract 240 from the y of obj while drawing, so we gotta apply that here too
                            local ppx, ppy = battle.soul.x - 40, battle.soul.y + 240 + 25
                            
                            if ppx < obj.x + obj.w and
                            ppx + battle.soul.w > obj.x and
                            ppy < obj.y + obj.h and
                            ppy + battle.soul.h > obj.y then
                                return true
                            end
                        end

                        return false
                    end
                end,

                draw = function(i, bottom, offset)
                    if battle.attackCache.pellets == nil then return end
                    for i = 1, #battle.attackCache.pellets.objs do
                        local offset = offset or false
                        -- draw a little small oval
                        local obj = battle.attackCache.pellets.objs[i]
                        if not obj then return end
                        local bottom = bottom or (obj.y < 240 and obj.y or obj.y - 240)
                        love.graphics.push()
                            love.graphics.translate(40, -25)
                            love.graphics.setColor(1,1,1)
                            love.graphics.ellipse("fill", obj.x, bottom, obj.w, obj.h)
                        love.graphics.pop()
                    end
                end,

                drawSeperate = function(i, bottom, offset)
                    if battle.attackCache.pellets == nil then return end
                    local offset = offset or false
                    -- draw a little small oval
                    local obj = battle.attackCache.pellets.objs[i]
                    if not obj then return end
                    love.graphics.push()
                        love.graphics.translate(40, -25)
                        love.graphics.setColor(1,1,1)
                        love.graphics.ellipse("fill", obj.x, bottom, obj.w, obj.h)
                    love.graphics.pop()
                end,

                hit = function() -- if it hits the player

                end,

                destroy = function() -- if it hits the player
                    -- delete all pellets
                    if battle.attackCache.pellets == nil then return end
                    battle.attackCache.pellets.objs = {}
                end,
            },
            pelletcircle = {
                attack = function()
                    -- same thing as pellets, but instead makes a circle of 25 pixel radius around the player and gets closer to the player
                    battle.attackCache.pelletcircle = {}
                    battle.attackCache.pelletcircle.objs = {}
                    local count = 32 -- # of pellets

                    for i = 1, count do
                        local obj = {
                            x = 152,
                            y = 66,
                            w = 5,
                            h = 5,
                            angle = math.rad(360/count*i),
                            spd = 0.125,
                            determinedAngle = false,
                            moveAngle = math.rad(360/count*i),
                        }
                        -- instantly set the x to 25 px away from the player
                        obj.x = obj.x + math.cos(obj.angle) * 75 - 35
                        obj.y = obj.y + math.sin(obj.angle) * 75 + 25
                        table.insert(battle.attackCache.pelletcircle.objs, obj)

                        
                    end

                    battle.spawnin:stop()
                    battle.spawnin:play()
                    print("pelletcircle attack")
                end,

                movein = false,

                update = function(gt, i)
                    curGameTime = math.floor(love.timer.getTime())
                    if battle.attackCache.pelletcircle == nil then return end
                    for i = 1, #battle.attackCache.pelletcircle.objs do
                        local obj = battle.attackCache.pelletcircle.objs[i]
                        if not obj then return end
                        __timer = __timer + 1
                        if __timer % 2 == 0 then -- second frame
                            obj.angle = obj.angle + math.rad(90)
                            __timer = 0
                        end
                        -- slowly move to player increasing in speed
                        if battle.enemy.attacks.pelletcircle.movein then
                            -- move to player
                            local px, py = 152-25, 66 + 20
                            local dx, dy = px - obj.x, py - obj.y
                            local angle = math.atan2(dy, dx)
                            obj.x = obj.x + math.cos(angle) * (obj.spd * 25) * gt
                            obj.y = obj.y + math.sin(angle) * (obj.spd * 25) * gt
                        end 
                    end
                end,

                isCollision = function(i)
                    -- checks if pellet is in contact with soul
                    if battle.attackCache.pelletcircle == nil then return end
                    for i=1,#battle.attackCache.pelletcircle.objs do
                        local obj = battle.attackCache.pelletcircle.objs[i]
                        if not obj then return end
                        if obj then
                            -- since after 240y, we subtract 240 from the y of obj while drawing, so we gotta apply that here too
                            local ppx, ppy = 152 - 40, 66
                            
                            -- if the distance is less than 55 px, then it's a hit
                            local dx, dy = ppx - obj.x, ppy - obj.y
                            local distance = math.sqrt(dx * dx + dy * dy)
                            if distance < 55 then
                                return true
                            end
                        end

                        return false
                    end
                end,

                draw = function(i, bottom, offset)
                    if battle.attackCache.pelletcircle == nil then return end
                    for i = 1, #battle.attackCache.pelletcircle.objs do
                        local offset = offset or false
                        -- draw a little small oval
                        local obj = battle.attackCache.pelletcircle.objs[i]
                        if not obj then return end
                        local bottom = bottom or (obj.y < 240 and obj.y or obj.y - 240)
                        love.graphics.push()
                            love.graphics.translate(40, -25)
                            love.graphics.setColor(1,1,1)
                            love.graphics.ellipse("fill", obj.x, bottom, obj.w, obj.h)
                        love.graphics.pop()
                    end
                end,

                destroy = function() -- if it hits the player
                    -- delete all pellets
                    if battle.attackCache.pelletcircle == nil then return end
                    battle.attackCache.pelletcircle.objs = {}
                end,
            }
        }
    }

    battle.heartType = 0
    battle.state = 'dialogue'

    battle.music = love.audio.newSource("mus_floweytheme0.wav", "stream")
    battle.music:setLooping(true)
    battle.music:setVolume(0.5)
    battle.music:play()
end

function bs.flowey.beginning.update(gt)
    if battle.state ~= "dothing" then
        battle.soul.hsp, battle.soul.vsp = 0,0
        if input:down("right") then battle.soul.hsp = battle.soul.hsp + battle.soul.spd end
        if input:down("left") then battle.soul.hsp = battle.soul.hsp - battle.soul.spd end
        if input:down("up") then battle.soul.vsp = battle.soul.vsp - battle.soul.spd end
        if input:down("down") then battle.soul.vsp = battle.soul.vsp + battle.soul.spd end

        battle.soul.doCollision()

        if battle.soul.vsp ~= 0 or battle.soul.hsp ~= 0 then
            battle.soul.x = battle.soul.x + battle.soul.hsp
            battle.soul.y = battle.soul.y + battle.soul.vsp
        end
    end
    if battle.state == "dialogue" then
        battle.enemy.dialogues.updateDialogue(gt, battle.enemy.dialogues.timeTimer <=0.0001)
        if input:pressed("a") and battle.enemy.dialogues.timeTimer <= 0.0001 then
            if battle.enemy.dialogues.showDialogue then
                battle.enemy.dialogues.changeDialogue()
            else
                battle.state = "move"
            end
        end
    end

    battle.enemy.attacks.pellets.update(gt)
    battle.enemy.attacks.pelletcircle.update(gt)

    if battle.enemy.attacks.pellets.movestuff and #battle.attackCache.pellets.objs == 0 then
        --TODO
    elseif battle.enemy.attacks.pellets.movestuff and battle.attackCache.pellets ~= nil then
        if battle.enemy.attacks.pellets.isCollision() then
            battle.state = "dialogue"
            battle.enemy.dialogues.main_animation = "grin"
            battle.enemy.dialogues.cur_animation = "grin"
            battle.enemy.attacks.pellets.movestuff = false
            battle.enemy.attacks.pellets.destroy()
            battle.enemy.dialogues.showDialogue = true
            battle.enemy.dialogues.curLine = 1
            battle.enemy.dialogues.curDialogue = ""
            battle.enemy.dialogues.curText = ""
            battle.enemy.dialogues.timer = 0.05
            battle.enemy.dialogues.curCharacter = 0
            battle.enemy.dialogues.largeText = false
            battle.enemy.dialogues.shakeyText = false
            battle.enemy.dialogues.curDialogueLines = 1

            battle.music:stop()
            battle.hurt:play()

            battle.health = 1

            battle.enemy.dialogues.blip = love.audio.newSource("dialogue/flowey/1.wav", "static")
        end
    end

    if battle.enemy.attacks.pelletcircle.movein and battle.attackCache.pelletcircle.objs ~= nil then
        if battle.enemy.attacks.pelletcircle.isCollision() then
            battle.laugh:stop()
            battle.health = 20
            battle.heal:play()

            battle.enemy.attacks.pelletcircle.movein = false
            battle.enemy.attacks.pelletcircle.destroy()

            doingCutscene = true
            part = 0
        end
    end

    if battle.laugh:isPlaying() then
        __timer = __timer + gt
        if __timer >= 1 then
            __timer = 0
            battle.enemy.frame = battle.enemy.frame + 1
            if battle.enemy.frame > #battle.enemy.body[battle.enemy.dialogues.cur_animation] then
                battle.enemy.frame = 0
            end
        end
    end

    -- I'm sowwy 3:
    if doingCutscene then
        __timer = __timer + gt
        if part == 0 then
            if __timer >= 1.35 then
                part = 1
                __timer = 0
                battle.enemy.dialogues.main_animation = "pissed"
            end
        elseif part == 1 then
            if __timer >= 0.55 then
                part = 2
                __timer = 0
                showFlames = true
            end
        elseif part == 2 then
            if __timer >= 0.05 then
                part = 3
                __timer = 0
                showFlames = false
            end
        elseif part == 3 then
            if __timer >= 0.05 then
                part = 4
                __timer = 0
                showFlames = true
            end
        elseif part == 4 then
            if __timer >= 0.05 then
                part = 5
                __timer = 0
                showFlames = false
            end
        elseif part == 5 then
            if __timer >= 0.05 then
                part = 6
                __timer = 0
                showFlames = true
            end
        elseif part == 6 then
            if __timer >= 0.5 then
                -- make flameX closer to battle.enemy.x
                flameX = flameX + (battle.enemy.x - flameX) / 10
                -- when its close enough, move to the next part
                if math.abs(battle.enemy.x - flameX) < 1 then
                    part = 7
                    __timer = 0
                    showFlames = false
                elseif math.abs(battle.enemy.x - flameX) < 5 then
                    battle.enemy.dialogues.main_animation = "shock"
                end
            end
        elseif part == 7 then
            battle.enemy.dialogues.main_animation = "pain"
            battle.enemy.angle = battle.enemy.angle - 10 * gt
            if battle.enemy.angle >= -120 then
                battle.enemy.angle = -120
            end
            battle.enemy.rotation = math.rad(battle.enemy.angle)
            -- make y go up very little and x go down a lot
            battle.enemy.y = battle.enemy.y - 5 * gt
            battle.enemy.x = battle.enemy.x + 15 * gt
            if battle.enemy.y <= 0 then
                battle.enemy.y = 0
                part = 8
                __timer = 0
            end
        elseif part == 8 then
            -- move torielX closer to the middle
            torielX = torielX + (160 - torielX) / 10
        end
    end
end

function bs.flowey.beginning.draw(screen)
    dslayout:draw(screen,
    function()
        -- TOP
        love.graphics.draw(battle.enemy.body[battle.enemy.dialogues.cur_animation][battle.enemy.frame], 150, 120, 0, 2, 2)

        -- draw the dialogue with fnt_small
        love.graphics.setFont(fnt_dialogue)
        battle.enemy.dialogues.drawDialogue()

        -- draw the attack
        if battle.attackCache.pellets ~= nil then
            for i = 1, #battle.attackCache.pellets.objs do
                local obj = battle.attackCache.pellets.objs[i]
                if obj then
                    local bottom = obj.y
                    if bottom < 240 then
                        obj.drawSeperate(i, bottom, true)
                    end
                end
            end
        end
    end,
    function()
        -- BOTTOM
        battle.box.draw()
        love.graphics.draw(battle.soul.spr[battle.heartType], battle.soul.x, battle.soul.y)
        -- draw the attack
        if battle.attackCache.pellets ~= nil then
            for i = 1, #battle.attackCache.pellets.objs do
                local obj = battle.attackCache.pellets.objs[i]
                if obj then
                    local bottom = obj.y
                    if bottom >= 240 then
                        obj.drawSeperate(i, bottom-240, true)
                    end
                end
            end
        end

        battle.enemy.attacks.pelletcircle.draw()

        love.graphics.setFont(fnt_curs)
        love.graphics.print("LV 1", 40, 185)
        love.graphics.setFont(fnt_small)
        love.graphics.print("HP", 110, 190, 0, 2.7, 2.7)
        -- draw a small square for the hp bar (yellow)
        
        -- 25px width changes w/ health
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle('fill', 145, 188, 25, 20)
        love.graphics.setColor(1,1,0,1)
        love.graphics.rectangle('fill', 145, 188, 25 * (battle.health / 20), 20)
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(fnt_curs)
        love.graphics.print(battle.health .. " / 20", 180, 185)
    end
    )
end