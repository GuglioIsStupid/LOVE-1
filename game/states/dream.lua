function gs.dream.load()
    mkey = {[0]=nil,[1]=nil}
    dream = {}
    dream.state = 'normal'
    dream.curRoom = 0
    dream.fade = 0
    dream.frameTimer = 0
    dream.warp = {go=0,spawn=0,transition=false}
    dream.pause = {
        select = 0,
        [0] = {name = 'ITEM',
            submenu = { 
                selected = false,
                type = 'msg',
                msg = '* Besides an old phone, your pockets are empty.',
            },
        },
        [1] = {name = 'STAT',
            submenu = { selected = false, x = 10, y = 50, w =50, h = 50,
                type = 'window',
                content = {
                    [0] = { 
                        x = 10, y = 10,
                        text = 'Frisk'
                    }
                }
            },
        },
        [2] = {name = 'CELL',
            submenu = { 
                selected = false,
                type = 'msg',
                msg = '* Looks like the battery is dead.',
            },
        },
    }

    dream.frisk = {
        x=170,y=140,dir=3,frame=0,spd=1.5,hsp=0,vsp=0,checked=false,
        spr = {
            normal = {
                [0] = {
                    [0] = love.graphics.newImage('dream/frisk/0_0.png'),
                    [1] = love.graphics.newImage('dream/frisk/0_1.png'),
                },
                [1] = {
                    [0] = love.graphics.newImage('dream/frisk/1_0.png'),
                    [1] = love.graphics.newImage('dream/frisk/1_1.png'),
                    [3] = love.graphics.newImage('dream/frisk/1_2.png'),
                },
                [2] = {
                    [0] = love.graphics.newImage('dream/frisk/2_0.png'),
                    [1] = love.graphics.newImage('dream/frisk/2_1.png'),
                },
                [3] = {
                    [0] = love.graphics.newImage('dream/frisk/3_0.png'),
                    [1] = love.graphics.newImage('dream/frisk/3_1.png'),
                    [3] = love.graphics.newImage('dream/frisk/3_2.png'),
                },
            },
            sleep = {}
        }
    }

    dream.room = {
        [0] = {
            bg = love.graphics.newImage('dream/room/0.png'),
            x = 90, -- room bg x offset
            y = 21, -- room bg y offset
            w = 400, --room width
            h = 240, -- room height
            wall = { --easy basic walls to set up
                [0] = 273, -- east x
                [1] = 100, -- north y
                [2] = 120, -- west x
                [3] = 272, -- south y
            },
            warp = { -- total number of warp/doors
                [0] = {x1 = 240, y1 = 200, x2 = 275, y2 = 215, go = 1, spawn = 0,}
            },
            spawn = { --where you spawn/ arrive from a warp
                [0] = {x = 257, y = 188, dir = 1},
            },
            object = {
                [0] = {x1 = 235, y1 = 97, x2 = 276, y2 = 140,},
                [1] = {x1 = 255, y1 = 137, x2 = 276, y2 = 160,},
                [2] = {x1 = 116, y1 = 195, x2 = 241, y2 = 215,},
            },
            entries = {
                [0] = {x1 }
            }
        },
        [1] = {
            bg = love.graphics.newImage('dream/room/1.png'),
            x = 0,
            y = 42,
            w = 400,
            h = 240,
            wall = { --easy basic walls to set up
                [0] = 400, -- east x
                [1] = 104, -- north y
                [2] = 0 , -- west x
                [3] = 169, -- south y
            },
            warp = { -- total number of warp/doors
                [0] = {x1 = 158, y1 = 105, x2 = 182, y2 = 116, go = 0, spawn = 0,},
            },
            spawn = { --where you spawn/ arrive from a warp
                [0] = {x = 170, y = 126, dir = 3,},
            },
            object = {
                [0] = {solid = true, x1 = 0, y1 = 105, x2 = 159, y2 = 121,
                    commment = {
                        [0] = nil,
                    },
                },
                [1] = {solid = true, x1 = 181, y1 = 105, x2 = 368, y2 = 121,
                    comment = {
                        [0] = nil,
                    },
                }, -- hole
                [2] = {solid = true, x1 = 258, y1 = 100, x2 = 331, y2 = 180,
                    comment = {
                        [0] = '* The hallway is seperated by a hole in the floor.',
                        [1] = '* The gap is too wide for you to jump across.',
                        [3] = '* You cannot see the bottom.',
                    },
                },
            }
        }
    }

    function dream.doCollision(x0, y0, hsp, vsp, curRoom)
        local x1 = x0 + hsp
        local y1 = y0 + vsp
        
        -- wall collisions
        if x1 > dream.room[curRoom].wall[0] then dream.frisk.hsp = 0 end
        if x1 < dream.room[curRoom].wall[2] then dream.frisk.hsp = 0 end
        if y1 > dream.room[curRoom].wall[3] then dream.frisk.vsp = 0 end
        if y1 < dream.room[curRoom].wall[1] then dream.frisk.vsp = 0 end

        -- object collisions
        for i = 0, #dream.room[curRoom].object do
            if hsp == 0 and vsp == 0 then break end
            if x1 > dream.room[curRoom].object[i].x1 and x1 < dream.room[curRoom].object[i].x2 and 
                y0 > dream.room[curRoom].object[i].y1 and y0 < dream.room[curRoom].object[i].y2 then
                dream.frisk.hsp = 0
            end
            if x0 > dream.room[curRoom].object[i].x1 and x0 < dream.room[curRoom].object[i].x2 and 
                y1 > dream.room[curRoom].object[i].y1 and y1 < dream.room[curRoom].object[i].y2 then
                dream.frisk.vsp = 0
            end
            if dream.room[curRoom].object[i+1] == nil then break end
        end

        --if x > dream.room[dream.curRoom].warp[i].x1 and x < dream.room[dream.curRoom].warp[i].x2 a
    end

    function dream.doWarp(room, spawn)
        dream.curRoom = room
        dream.frisk.x = dream.room[room].spawn[spawn].x
        dream.frisk.y = dream.room[room].spawn[spawn].y
        dream.frisk.dir = dream.room[room].spawn[spawn].dir
    end

    function dream.checkWarp(x, y)
        for i = 0, #dream.room[dream.curRoom].warp do
            if x > dream.room[dream.curRoom].warp[i].x1 and x < dream.room[dream.curRoom].warp[i].x2 and y > dream.room[dream.curRoom].warp[i].y1 and y < dream.room[dream.curRoom].warp[i].y2 then
                dream.warp.go = dream.room[dream.curRoom].warp[i].go
                dream.warp.spawn = dream.room[dream.curRoom].warp[i].spawn
                dream.warp.transition = 0
                dream.state = "warp"
                dream.frameTimer = 0
            end
            if dream.room[dream.curRoom].warp[i+1] == nil then break end
        end
    end

    function dream.doCheck(x, y, dir)
        dream.frisk.hsp, dream.frisk.vsp = 0, 0
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

    function dream.drawMenu(x,y,w,h,d)
        love.graphics.setDepth(d)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill', x, y, w, h)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('fill', x+3, y+3, w-6, h-6)
        love.graphics.setColor(1,1,1)
    end
end

function gs.dream.update(gt)
    if dream.state == "normal" then
        dream.frisk.hsp, dream.frisk.vsp = 0, 0
        dream.frameTimer = dream.frameTimer + 5 * gt
        dream.frisk.frame = 0
        if not input:pressed("a") then dream.frisk.checked = false end
        if input:down("right") then dream.frisk.hsp = dream.frisk.hsp + dream.frisk.spd end
        if input:down("left") then dream.frisk.hsp = dream.frisk.hsp - dream.frisk.spd end
        if input:down("down") then dream.frisk.vsp = dream.frisk.vsp + dream.frisk.spd end
        if input:down("up") then dream.frisk.vsp = dream.frisk.vsp - dream.frisk.spd end
        if input:pressed("a") and not dream.frisk.checked then
            dream.doCheck(dream.frisk.x, dream.frisk.y, dream.frisk.dir)
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
        if mkey[0] ~= nil then dream.frisk.dir = mkey[0] end

        dream.checkWarp(dream.frisk.x, dream.frisk.y)
        dream.doCollision(dream.frisk.x, dream.frisk.y, dream.frisk.hsp, dream.frisk.vsp, dream.curRoom)

        if dream.frisk.vsp ~= 0 or dream.frisk.hsp ~= 0 then
            dream.frisk.x = dream.frisk.x + dream.frisk.hsp
            dream.frisk.y = dream.frisk.y + dream.frisk.vsp
            if dream.frameTimer >= 4 then dream.frameTimer = 0 end
            if dream.frameTimer >= 2 and (dream.frisk.dir == 0 or dream.frisk.dir == 2) then dream.frameTimer = 0 end
            dream.frisk.frame = math.floor(dream.frameTimer)
        else
            dream.frameTimer = 0
        end
        if input:pressed("start") then
            dream.state = "pause"
            snd_menu:play()
        end
    elseif dream.state == "interact" then
        dream.checkWarp(dream.frisk.x, dream.frisk.y)
    elseif dream.state == "pause" then
        if input:pressed("start") then
            dream.state = "normal"
            snd_menu:play()
        end
    elseif dream.state == "warp" then
        if dream.warp.transition then
            if dream.frameTimer < 1 then
                dream.frameTimer = dream.frameTimer + 2 * gt
            else
                dream.doWarp(dream.warp.go, dream.warp.spawn)
                dream.warp.transition = false
                dream.frameTimer = 1
            end
        else
            if dream.frameTimer > 0 then
                dream.frameTimer = dream.frameTimer - 2 * gt
            else
                dream.state = "normal"
                dream.frameTimer = 0
            end
        end
        dream.fade = 1 * dream.frameTimer
        if dream.fade < 0 then dream.fade = 0 end
        if dream.fade > 1 then dream.fade = 1 end
    end
end

function gs.dream.draw(screen)
    dslayout:draw(screen,
    function()
        -- TOP
        love.graphics.setFont(fnt_main)
        love.graphics.setDepth(0)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(dream.room[dream.curRoom].bg, dream.room[dream.curRoom].x, dream.room[dream.curRoom].y)
        if dream.frisk.spr.normal[dream.frisk.dir][dream.frisk.frame] == nil then
            love.graphics.draw(dream.frisk.spr.normal[dream.frisk.dir][0], dream.frisk.x-9, dream.frisk.y-26)
        else
            love.graphics.draw(dream.frisk.spr.normal[dream.frisk.dir][dream.frisk.frame], dream.frisk.x-9, dream.frisk.y-26)
        end
        if dream.state == "warp" then
            love.graphics.setColor(0,0,0,dream.fade)
            love.graphics.rectangle('fill', -5, -5, 405, 245)
        end
        if dream.state == "pause" then
            dream.drawMenu(26, 26, 70, 60, -2)
            dream.drawMenu(26, 94, 70, 75, -2)
            love.graphics.setColor(1,1,1)
            love.graphics.setDepth(-3)
            love.graphics.print("Frisk", 35, 28)
            love.graphics.setDepth(-2)
            love.graphics.print("LV", 35, 47)
            love.graphics.print("HP", 35, 56)
            love.graphics.print("G", 35, 65)
            love.graphics.print("1", 52, 47)
            love.graphics.print("20/20", 52, 56)
            love.graphics.print("0", 52, 65)

            love.graphics.print(dream.pause[0].name, 50, 101)
            love.graphics.print("STAT", 50, 119)
            love.graphics.print("CELL", 50, 137)
        end        
    end,
    function()
        -- BOTTOM
        
    end
    )
end