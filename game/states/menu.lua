function gs.menu.load()
    idleTimer = 0
    allowInput = false
    menu = {}
    menu.state = false
    menu.timer = 0
    menu.keyDelay = 0
    menu.img_door = love.graphics.newImage('menu/door.png')
    menu.img_patch = love.graphics.newImage('menu/patch.png')
    menu.img_tori0 = love.graphics.newImage('menu/tori0.png')
    menu.img_tori1 = love.graphics.newImage('menu/tori1.png')
    menu.list = {{string="Start", selected=true, go="dream"}, {string='Quit', selected=false, go="quit"}}
    menu.select = 1
    menu.playing = false
    menu.fade = 0
    menu.bgm = love.audio.newSource('mus_menu0.wav', 'stream')
    menu.bgm:setLooping(true)

    function menu.leave()
        menu.bgm:release()
        menu.bgm = nil
        menu = nil
    end
    
    function menu.introTimout(ft)
        allowInput = false
        if menu.fade < 1 then
            menu.fade = menu.fade + ft
        end
        if menu.fade > 1 then menu.fade = 1 end
        if menu.fade == 1 then
            changeState('intro')
        end
    end
end

function gs.menu.update(gt)
    if not menu.playing then 
        love.audio.stop()
        menu.playing = true
        menu.bgm:play()
        allowInput = true
    end
    if idleTimer >= 20 then menu.introTimout(gt)
    else
        menu.timer = menu.timer + gt
        if menu.keyDelay > 0 then
            menu.keyDelay = menu.keyDelay - gt
        elseif menu.keyDelay < 0 then
            menu.keyDelay = 0
        end
        if menu.timer >= 1.5 then
            menu.state = not menu.state
            menu.timer = 0
        end
        if menu.keyDelay == 0  then
            if allowInput then
                if input:pressed("a") then
                    menu.keyDelay = 0.5
                    if menu.list[menu.select].go == "quit" then
                        love.event.quit()
                    else
                        changeState(menu.list[menu.select].go)
                    end
                end
                if input:down("right") then
                    menu.keyDelay = 0.2
                    menu.list[menu.select].selected = false
                    menu.select = menu.select + 1
                    if menu.select > #menu.list then menu.select = 1 end
                    menu.list[menu.select].selected = true
                elseif input:down("left") then
                    menu.keyDelay = 0.2
                    menu.list[menu.select].selected = false
                    menu.select = menu.select - 1
                    if menu.select < 1 then menu.select = #menu.list end
                    menu.list[menu.select].selected = true
                end
            end
        end
    end
end

function gs.menu.draw(screen)
    dslayout:draw(screen,
    function()
        love.graphics.setFont(fnt_main)
        love.graphics.setDepth(-1)
        for i = 1, #menu.list do
            if menu.list[i].selected then love.graphics.setColor(1, 1, 0, 1)
            else love.graphics.setColor(1, 1, 1, 1) end
            love.graphics.print(menu.list[i].string, 125 + (i - 1) * 90, 114)
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setDepth(4)
        love.graphics.draw(menu.img_door, 149, 0)
        love.graphics.setDepth(2)
        love.graphics.draw(menu.img_patch, 121, 179)

        if menu.state then
            love.graphics.draw(menu.img_tori0, 173, 141)
        else
            love.graphics.draw(menu.img_tori1, 173, 141)
        end
        love.graphics.setDepth(0)
        love.graphics.setColor(0,0,0,menu.fade)
        love.graphics.rectangle('fill', 0, 0, 400, 240)
    end,
    function()
        -- BOTTOM
        love.graphics.setDepth(1)
        love.graphics.setFont(fnt_small)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("LOVE " .. __GAME_VERSION .. '\n\nBY XAVYRR\n\nFINISHED BY GUGLIOISSTUPID\n\nUNDERTALE ASSETS (C) TOBY FOX', 0, 0, 240, 'left')
    end
    )
end

function gs.menu.leave()
    menu.bgm:release()
    menu = nil
end