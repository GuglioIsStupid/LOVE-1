__GAME_VERSION = "V0.1"
idleTimer = 0

function love.load()
    require "libs.dslayout"
    dslayout:init({
        color = { r = 0.2, g = 0.2, b = 0.25, a = 1 },
        title = "UNDERTALE"
    })

    -- libs
    baton = require "libs.baton"

    -- modules
    require "modules.overrides"
    -- Setups
    input = baton.new {
        controls = {
            left = {'key:left', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'axis:lefty+', 'button:dpdown'},

            a = {'key:x', 'button:a'},
            b = {'key:z', 'button:b'},

            start = {'key:return', 'button:start'},
            select = {'key:rshift', 'button:back'},

            l = {'key:l', 'button:leftshoulder'},
            r = {'key:r', 'button:rightshoulder'},
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
        deadzone = 0.25
    }
    
    gs = {
        start = {load, draw, update},
        menu = {load, draw, update},
        intro = {load, draw, update},
        dream = {load, draw, update},
        ruins = {load, draw, update},
    }
    require "states.start"
    require "states.menu"
    require "states.dream"
    require "states.intro"
    require "states.ruins"

    function load(state)
        gameState = state
        love.audio.stop()
        print("Loading " .. state .. "...")
        gs[gameState].load()
    end
    
    function changeState(state)
        gs[gameState].leave()
        love.audio.stop()
        load(state)
    end

    gameState = "start"
    load(gameState)
    fnt_main = love.graphics.newFont('fnt_main.ttf', 16)
    fnt_small = love.graphics.newFont('fnt_small.ttf', 8)
    img_select = love.graphics.newImage('menu/soul_small.png')
    img_flower = love.graphics.newImage('dream/flower.png')
    snd_menu = love.audio.newSource('snd_menu.wav', 'stream')

    gt = 0 -- game time
    math.randomseed(os.time())
end

function love.update(dt)
    input:update()
    if dt >= 1 then gt = 0.000001
    else gt = dt end
    idleTimer = idleTimer + gt
    gs[gameState].update(dt)
    if input:pressed("select") then love.event.quit() end
end

function love.mousemoved(x,y,dx,dy,istouch)
  dslayout:mousemoved(x,y,dx,dy,istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
  dslayout:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
  dslayout:mousereleased(x, y, button, istouch, presses)
end

function love.draw(screen)
    gs[gameState].draw(screen)
end

function love.quit()
    print("Thanks for playing! Come back soon!")
end
--[[
    dslayout:draw(screen,
    function()
        -- TOP
    end,
    function()
        -- BOTTOM
    end
    )
--]]