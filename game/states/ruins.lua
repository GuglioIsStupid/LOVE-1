function gs.ruins.load()
    mkey = {[0]=nil,[1]=nil}
    ruin = {}
    ruin.state = 'normal'
    ruin.curRoom = 0
    ruin.fade = 0
    ruin.frameTimer = 0
    ruin.warp = {go=0,spawn=0,transition=false}
    ruin.pause = {}

    ruin.frisk = {
        x=170,y=140,dir=3,frame=0,spd=1.5,hsp=0,vsp=0,checked=false,
        spr = {
            normal = {
                [0] = {
                    [0] = love.graphics.newImage('frisk/0_0.png'),
                    [1] = love.graphics.newImage('frisk/0_1.png'),
                },
                [1] = {
                    [0] = love.graphics.newImage('frisk/1_0.png'),
                    [1] = love.graphics.newImage('frisk/1_1.png'),
                    [3] = love.graphics.newImage('frisk/1_2.png'),
                },
                [2] = {
                    [0] = love.graphics.newImage('frisk/2_0.png'),
                    [1] = love.graphics.newImage('frisk/2_1.png'),
                },
                [3] = {
                    [0] = love.graphics.newImage('frisk/3_0.png'),
                    [1] = love.graphics.newImage('frisk/3_1.png'),
                    [3] = love.graphics.newImage('frisk/3_2.png'),
                },
            },
            sleep = {}
        }
    }

    ruin.room = {
        [0] = {
            bg = love.graphics.newImage('ruins/room/0.png'),
            x=0,y=0,
            w=680,h=260,
            wall = { -- 0 = east X, 1 = north Y, 2 = west X, 3 = south Y
                [0] = 660,
                [1] = 60,
                [2] = 20,
                [3] = 240,
            },
            warp = {
                [0] = {x1=590,y1=110,x2=626,y2=131, go=1, spawn=0}
            },
            spawn = {
                [0] = {x=140,y=120,dir=2},
            },
            object = {
                
            },
        },
        [1] = {
            bg = love.graphics.newImage('ruins/room/1.png'),
            x=0,y=0,
            w=319,h=331,
            wall = { -- 0 = east X, 1 = north Y, 2 = west X, 3 = south Y
                [0] = 320,
                [1] = -331,
                [2] = 0,
                [3] = 390,
            },
            warp = {
                [0] = {x1=590,y1=131,x2=626,y2=110, go=1, spawn=0}
            },
            spawn = {
                [0] = {x=150,y=370,dir=1},
            },
            object = {
                
            },
        }
    }

    ruin.killedFlowey = false

    ruin.flowey = {
        x=148,y=285,frame=0,
        spr = {
            normal = {
                -- basically the "idle" animation
                [0] = love.graphics.newImage("npc/flowey/0.png")
            },
            talking = {
                [0] = love.graphics.newImage("npc/flowey/0.png"),
                [1] = love.graphics.newImage("npc/flowey/1.png")
            }
        }
    }

    ruin.camera = {
        x=0,y=0,
        minX=0,minY=0,
        maxX=680-320,maxY=280,
        update = function()
            if ruin.frisk.x > ruin.camera.maxX then
                ruin.camera.x = ruin.camera.maxX
            elseif ruin.frisk.x < ruin.camera.minX then
                ruin.camera.x = ruin.camera.minX
            else
                ruin.camera.x = ruin.frisk.x
            end
            if ruin.frisk.y > ruin.camera.maxY then
                ruin.camera.y = ruin.camera.maxY
            elseif ruin.frisk.y < ruin.camera.minY then
                ruin.camera.y = ruin.camera.minY
            else
                ruin.camera.y = ruin.frisk.y
            end
        end
    }

    function ruin.doCollision(x0, y0, hsp, vsp, curRoom)
        local x1 = x0 + hsp
        local y1 = y0 + vsp
        
        -- wall collisions
        if x1 > ruin.room[curRoom].wall[0] then ruin.frisk.hsp = 0 end
        if x1 < ruin.room[curRoom].wall[2] then ruin.frisk.hsp = 0 end
        if y1 > ruin.room[curRoom].wall[3] then ruin.frisk.vsp = 0 end
        if y1 < ruin.room[curRoom].wall[1] then ruin.frisk.vsp = 0 end

        -- object collisions
        for i = 0, #ruin.room[curRoom].object do
            -- if there is a object then continue, else break
            if ruin.room[curRoom].object[i] == nil then break end
            if hsp == 0 and vsp == 0 then break end
            if x1 > ruin.room[curRoom].object[i].x1 and x1 < ruin.room[curRoom].object[i].x2 and 
                y0 > ruin.room[curRoom].object[i].y1 and y0 < ruin.room[curRoom].object[i].y2 then
                ruin.frisk.hsp = 0
            end
            if x0 > ruin.room[curRoom].object[i].x1 and x0 < ruin.room[curRoom].object[i].x2 and 
                y1 > ruin.room[curRoom].object[i].y1 and y1 < ruin.room[curRoom].object[i].y2 then
                ruin.frisk.vsp = 0
            end
            if ruin.room[curRoom].object[i+1] == nil then break end
        end

        --if x > ruin.room[ruin.curRoom].warp[i].x1 and x < ruin.room[ruin.curRoom].warp[i].x2 a
    end

    function ruin.doWarp(room, spawn)
        ruin.curRoom = room
        ruin.frisk.x = ruin.room[room].spawn[spawn].x
        ruin.frisk.y = ruin.room[room].spawn[spawn].y
        ruin.frisk.dir = ruin.room[room].spawn[spawn].dir
    end

    function ruin.checkWarp(x, y)
        for i = 0, #ruin.room[ruin.curRoom].warp do
            -- if theres a warp then continue, else break
            if ruin.room[ruin.curRoom].warp[i] == nil then break end
            if x > ruin.room[ruin.curRoom].warp[i].x1 and x < ruin.room[ruin.curRoom].warp[i].x2 and y > ruin.room[ruin.curRoom].warp[i].y1 and y < ruin.room[ruin.curRoom].warp[i].y2 then
                ruin.warp.go = ruin.room[ruin.curRoom].warp[i].go
                ruin.warp.spawn = ruin.room[ruin.curRoom].warp[i].spawn
                ruin.warp.transition = 0
                ruin.state = "warp"
                ruin.frameTimer = 0
            end
            if ruin.room[ruin.curRoom].warp[i+1] == nil then break end
        end
    end

    function ruin.doCheck(x, y, dir)
        ruin.frisk.hsp, ruin.frisk.vsp = 0, 0
        if dir == 0 then
            -- facing right
        elseif dir == 1 then
            -- facing up
        elseif dir == 2 then
            -- facing left
        else
            -- facing down 
        end
    end
end

function gs.ruins.update(dt)
    if ruin.state == "normal" then
        ruin.frisk.hsp, ruin.frisk.vsp = 0, 0
        ruin.frameTimer = ruin.frameTimer + 5 * gt
        ruin.frisk.frame = 0
        if not input:pressed("a") then ruin.frisk.checked = false end
        if input:down("right") then ruin.frisk.hsp = ruin.frisk.hsp + ruin.frisk.spd end
        if input:down("left") then ruin.frisk.hsp = ruin.frisk.hsp - ruin.frisk.spd end
        if input:down("down") then ruin.frisk.vsp = ruin.frisk.vsp + ruin.frisk.spd end
        if input:down("up") then ruin.frisk.vsp = ruin.frisk.vsp - ruin.frisk.spd end
        if input:pressed("a") and not ruin.frisk.checked then
            ruin.doCheck(ruin.frisk.x, ruin.frisk.y, ruin.frisk.dir)
        end

        if mkey[0] == nil then
            if input:down("right") then mkey[0] = 0
            elseif input:down("up") then mkey[0] = 1
            elseif input:down("left") then mkey[0] = 2
            elseif input:down("down") then mkey[0] = 3
            end
        else
            if mkey[0] == 0 and not input:down("right") then mkey[0] = nil
            elseif mkey[0] == 1 and not input:down("up") then mkey[0] = nil
            elseif mkey[0] == 2 and not input:down("left") then mkey[0] = nil
            elseif mkey[0] == 3 and not input:down("down") then mkey[0] = nil
            else -- nothing
            end
        end
        if mkey[1] == nil and mkey[0] ~= nil then
            if mkey[0] == 0 then
                if input:down("up") then mkey[1] = 1
                elseif input:down("left") then mkey[1] = 2
                elseif input:down("down") then mkey[1] = 3
                end
            elseif mkey[0] == 1 then
                if input:down("left") then mkey[1] = 2
                elseif input:down("down") then mkey[1] = 3
                elseif input:down("right") then mkey[1] = 0
                end
            elseif mkey[0] == 2 then
                if input:down("down") then mkey[1] = 3
                elseif input:down("right") then mkey[1] = 0
                elseif input:down("up") then mkey[1] = 1
                end
            elseif mkey[0] == 3 then
                if input:down("right") then mkey[1] = 0
                elseif input:down("up") then mkey[1] = 1
                elseif input:down("left") then mkey[1] = 2
                end
            end
        else
            if mkey[1] == 0 and not input:down("right") then mkey[1] = nil
            elseif mkey[1] == 1 and not input:down("up") then mkey[1] = nil
            elseif mkey[1] == 2 and not input:down("left") then mkey[1] = nil
            elseif mkey[1] == 3 and not input:down("down") then mkey[1] = nil
            else -- nothing
            end
        end
        
        if mkey[0] == nil then
            mkey[0] = mkey[1]
            mkey[1] = nil
        end
        if mkey[0] ~= nil then ruin.frisk.dir = mkey[0] end

        ruin.checkWarp(ruin.frisk.x, ruin.frisk.y)
        ruin.doCollision(ruin.frisk.x, ruin.frisk.y, ruin.frisk.hsp, ruin.frisk.vsp, ruin.curRoom)

        if ruin.frisk.vsp ~= 0 or ruin.frisk.hsp ~= 0 then
            ruin.frisk.x = ruin.frisk.x + ruin.frisk.hsp
            ruin.frisk.y = ruin.frisk.y + ruin.frisk.vsp
            if ruin.frameTimer >= 4 then ruin.frameTimer = 0 end
            if ruin.frameTimer >= 2 and (ruin.frisk.dir == 0 or ruin.frisk.dir == 2) then ruin.frameTimer = 0 end
            ruin.frisk.frame = math.floor(ruin.frameTimer)
        else
            ruin.frameTimer = 0
        end
        if input:pressed("start") then
            ruin.state = "pause"
            snd_menu:play()
        end
    elseif ruin.state == "interact" then
        ruin.checkWarp(ruin.frisk.x, ruin.frisk.y)
    elseif ruin.state == "pause" then
        if input:pressed("start") then
            ruin.state = "normal"
            snd_menu:play()
        end
    elseif ruin.state == "warp" then
        if ruin.warp.transition then
            if ruin.frameTimer < 1 then
                ruin.frameTimer = ruin.frameTimer + 2 * gt
            else
                ruin.doWarp(ruin.warp.go, ruin.warp.spawn)
                ruin.warp.transition = false
                ruin.frameTimer = 1
            end
        else
            if ruin.frameTimer > 0 then
                ruin.frameTimer = ruin.frameTimer - 2 * gt
            else
                ruin.state = "normal"
                ruin.frameTimer = 0
            end
        end
        ruin.fade = 1 * ruin.frameTimer
        if ruin.fade < 0 then ruin.fade = 0 end
        if ruin.fade > 1 then ruin.fade = 1 end
    end

    print(ruin.frisk.x, ruin.frisk.y)

    ruin.camera.x = (ruin.frisk.x ~= nil and ruin.frisk.x or 0) - 160
    ruin.camera.y = (ruin.frisk.y ~= nil and ruin.frisk.y or 0) - 120
end

function gs.ruins.draw()
    dslayout:draw(screen,
    function()
        -- TOP
        love.graphics.setFont(fnt_main)
        love.graphics.setDepth(0)
        love.graphics.setColor(1,1,1)
        love.graphics.push()
            love.graphics.translate(-ruin.camera.x, -ruin.camera.y)
            love.graphics.draw(ruin.room[ruin.curRoom].bg, ruin.room[ruin.curRoom].x, ruin.room[ruin.curRoom].y)
            if not ruin.killedFlowey and ruin.curRoom == 1 then
                love.graphics.draw(ruin.flowey.spr.normal[ruin.flowey.frame], ruin.flowey.x, ruin.flowey.y)
            end
        love.graphics.pop()
        if ruin.frisk.spr.normal[ruin.frisk.dir][ruin.frisk.frame] == nil then
            love.graphics.draw(ruin.frisk.spr.normal[ruin.frisk.dir][0], -9, -26)
        else
            love.graphics.draw(ruin.frisk.spr.normal[ruin.frisk.dir][ruin.frisk.frame], 170-9, 140-26)
        end
    end,
    function()
        -- BOTTOM
    end
    )
end

function gs.ruins.leave()

end