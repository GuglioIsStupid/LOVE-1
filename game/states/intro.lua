function gs.intro.load()
    allowInput = true
    intro = {}
    intro.x, intro.y = 100, 25
    fnt_mono = love.graphics.newFont('fnt_main_mono.otf', 16)
    intro.art = {
        [0] = {
            [1] = nil,
            [2] = love.graphics.newImage('intro/intro_0+2.png')
        },
        [1] = {
            [0] = love.graphics.newImage('intro/intro_1.png'),
            [1] = love.graphics.newImage('intro/intro_1+1.png'),
            [2] = love.graphics.newImage('intro/intro_1+2.png'),
        },
        [2] = {
            [-4] = love.graphics.newImage('intro/intro_2-4.png'),
            [-3] = love.graphics.newImage('intro/intro_2-3.png'),
            [-2] = love.graphics.newImage('intro/intro_2-2.png'),
            [-1] = love.graphics.newImage('intro/intro_2-1.png'),
            [0] = love.graphics.newImage('intro/intro_2.png'),
        },
        [3] = {
            [0] = love.graphics.newImage('intro/intro_3.png'),
        },
        [4] = {
            [0] = nil
        },
        [5] = {
            [-4] = love.graphics.newImage('intro/intro_5-4.png'),
            [-1] = love.graphics.newImage('intro/intro_5-1.png'),
            [0] = love.graphics.newImage('intro/intro_5.png'),
        },
        [6] = {
            [0] = love.graphics.newImage('intro/intro_6.png'),
        },
        [7] = {
            [-3] = love.graphics.newImage('intro/intro_7-3.png'),
            [-2] = love.graphics.newImage('intro/intro_7-2.png'),
            [0] = love.graphics.newImage('intro/intro_7.png'),
            [2] = love.graphics.newImage('intro/intro_7+2.png'),
            [3] = love.graphics.newImage('intro/intro_7+3.png'),
        },
        [8] = {
            [0] = love.graphics.newImage('intro/intro_8.png'),
        },
        [9] = {
            [0] = love.graphics.newImage('intro/intro_9.png'),
        },
    
        pos = {
            [0] = { [1] = { x = nil, y = nil }, [2] = { x = 35, y = 13 } },
            [1] = {
                [0] = {x = 0, y = 0},
                [1] = {x = -2, y = 31},
                [2] = {x = 18, y = 1},
            },
            [2] = {
                [-4] = {x = -8, y = 0},
                [-3] = {x = -6, y = 5},
                [-2] = {x = -4, y = 26},
                [-1] = {x = -3, y = 33},
                [0] = {x = 0, y = 64},
            },
            [3] = {
                [0] = {x = 0, y = 0},
            },
            [4] = nil,
            [5] = {
                [-4] = {x = -5, y = 0},
                [-1] = {x = -2, y = 71},
                [0] = {x = 53, y = 68},
            },
            [6] = {
                [0] = {x = 0, y = 0},
            },
            [7] = {
                [-3] = {x = 0, y = 38},
                [-2] = {x = 0, y = 0},
                [0] = {x = 0, y = 45},
                [2] = {x = 48, y = 0},
                [3] = {x = 15, y = 42},
            },
            [8] = {
                [0] = {x = 0, y = 0},
            },
            [9] = {
                [0] = {x = 0, y = 0},
            },
        },
    }

    nbsp = '\n'
    intro.string = {
        [0] = ('Long ago, two races ' .. nbsp:rep(2) .. ' ruled over Earth: ' .. nbsp:rep(2) .. ' HUMANS and MONSTERS.'),
        [1] = ('One day, war broke ' .. nbsp:rep(2) .. ' out between the two ' .. nbsp:rep(2) .. ' races.'),
        [2] = ('After a long battle, ' .. nbsp .. ' the humans were ' .. nbsp:rep(2) .. ' victorious.'),
        [3] = ('They sealed the ' .. nbsp:rep(2) .. ' monsters undergound ' .. nbsp:rep(2) .. ' with a magic spell.'),
        [4] = ('Many years later...'),
        [5] = (nbsp:rep(2) .. ' MT. EBOTT ' .. nbsp:rep(2) .. ' ' .. nbsp:rep(2) .. ' 201X' ),
        [6] = ('Legends say that those who climb the mountain never return.'),
        [7] = (' '),
        [8] = (' '),
        [9] = (' '),
    }
    
    intro.state = 0
    intro.timer = -4
    intro.curLen = 0
    intro.fade = 1
    intro.textSound = love.audio.newSource('snd_text.wav', 'static')
    len = 0
    intro.pause = false
    function intro.doString(gt)
        len = string.len(intro.string[intro.state])
        if string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == '%'  or string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == '\n'then intro.curLen = intro.curLen + 1 end
        if string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == ','  or string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == ':'then intro.timer = intro.timer - (gt / 1.10) end
        if string.sub(intro.string[intro.state], intro.curLen, intro.curLen + 1) == '..' then intro.timer = intro.timer - (gt / 1.05) end

        if intro.timer > 4 then
            intro.curLen = 0
            intro.state = intro.state + 1
            if intro.state < 7 then 
                intro.textSound:play()
                print(intro.state)
            end
            intro.timer = -4
        end
    end

    function intro.drawArt()
        for i = -4, 4 do
            if intro.art[intro.state][i] ~= nil then
                love.graphics.setDepth(-i)
                love.graphics.draw(intro.art[intro.state][i], intro.art.pos[intro.state][i].x + intro.x, intro.art.pos[intro.state][i].y + intro.y)
            elseif i == 0 and intro.state ~= 4 then
                love.graphics.setDepth(0)
                love.graphics.setColor(192/255, 130/255, 38/255)
                love.graphics.rectangle("fill", 100, 25, 200, 110)
            end
            love.graphics.setDepth(0)
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle('fill', 0, 25, 100, 110)
            love.graphics.rectangle('fill', 300, 25, 100, 110)
            love.graphics.setColor(0, 0, 0, intro.fade)
            love.graphics.rectangle('fill', 90, 15, 210, 120)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    function intro.drawString()
        love.graphics.setDepth(-1)
        love.graphics.setColor(1,1,1)
        if intro.string[intro.state] ~= nil then
            love.graphics.printf(intro.string[intro.state], 99, 150, 202, 'center')
        end
    end
    function intro.leave()
        intro.textSound:release()
        intro.textSound = nil
        intro = nil
    end
end

function gs.intro.update(gt)
    if not intro.pause then
        intro.timer = intro.timer + gt
        if intro.timer < 0 and intro.timer > -3 and intro.fade > 0 then
            intro.fade = intro.fade - gt
        end
        if intro.fade < 0 then intro.fade = 0 end
        if intro.timer > 3 and intro.fade < 1 then
            intro.fade = intro.fade + gt
        end
        if intro.fade > 1 then intro.fade = 1 end
        intro.doString(gt)
    end
    if input:pressed("a") then
        intro.pause = not intro.pause
    end
    if intro.state > 9 or input:pressed("start") then
        changeState("menu")
    end
end

function gs.intro.draw(screen)
    dslayout:draw(screen,
    function()
        love.graphics.setFont(fnt_mono)
        intro.drawArt()
        intro.drawString()
    end,
    function()
        -- BOTTOM
        love.graphics.setDepth(0)
        love.graphics.printf('-Press (A) to pause/unpause-', 10, 60, 300, 'center')
        if intro.pause then
            love.graphics.setColor(255, 255, 255, 60)
            love.graphics.printf('PAUSED', 10, 320/2, 300, 'center')
        end
    end
    )
end