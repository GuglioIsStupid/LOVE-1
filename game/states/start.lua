function gs.start.load()
    start = {}
    start.timer = -3
    start.state = 0
    start.image0 = love.graphics.newImage('start/start0.png')
    start.image1 = love.graphics.newImage('start/start1.png')
    start.image2 = love.graphics.newImage('start/start2.png')
    start.image3 = love.graphics.newImage('start/start3.png')
    start.noise = love.audio.newSource('start/snd_intronoise.wav', 'static')
end

function gs.start.update(gt)
    start.timer = start.timer + gt
    print(start.timer, start.state)
    if start.timer >= 0 and start.state == 0 then
        start.state = 1 
        start.noise:play()
    elseif start.timer >= 5 and start.state == 1 then
        start.state = 2
        start.depth = 0
        start.noise:play()
    elseif start.timer >= 10 and start.state == 2 then
        start.state = 3
        start.depth = 0
        start.noise:play()
    elseif (start.timer >= 13 and start.state == 3) or input:pressed("a") then
        changeState("menu")
    end
end

function gs.start.draw(screen)
    dslayout:draw(screen,
    function() 
        -- TOP
        love.graphics.setDepth(0)
        if start.state == 1 then
            love.graphics.draw(start.image0, 0, 0)
            love.graphics.setDepth(-2)
            love.graphics.draw(start.image1, 0, 0)
        elseif start.state == 2 then
            love.graphics.draw(start.image2, 0, 0)
            love.graphics.setDepth(-2)
            love.graphics.draw(start.image3, 0, 0)
        end
    end, 
    function()
        -- BOTTOM
    end)
end

function gs.start.leave()
    start.noise:release()
    start = nil
end