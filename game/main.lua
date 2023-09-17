__GAME_VERSION = "V0.1"
idleTimer = 0

require "modules.overrides"

function love.load()
    require "libs.dslayout"
    dslayout:init({
        color = { r = 0.2, g = 0.2, b = 0.25, a = 1 },
        title = "UNDERTALE"
    })

    love.graphics.setDefaultFilter("nearest", "nearest")

    -- libs
    baton = require "libs.baton"
    debugGraph = require 'libs.debugGraph'
    Timer = require "libs.timer"

    -- modules
    
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
    
    -- States
    gs = { -- as in "game state"
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

    -- Battles
    bs = {
        flowey = {
            beginning = {load, draw, update}
        }
    } -- as in "battle state"
    require "battles.ruins.flowey.beginning" -- very first battle of the game.

    function load(state)
        gameState = state
        love.audio.stop()
        --print("Loading " .. state .. "...")
        gs[gameState].load()
    end
    
    function changeState(state)
        gs[gameState].leave()
        love.audio.stop()
        load(state)
    end

    function setBattle(state)
        -- if state starts with "flowey", then split it from .
        gameState = "battle"
        battleState = state
        if state:startsWith("flowey") then
            bs["flowey"][state:split(".")[2]].load()
            return
        end
        bs[state].load()
    end

    gameState = "start"
    battleState = "none"
    load(gameState)
    fnt_main = love.graphics.newFont('fnt_main.ttf', 16)
    fnt_dialogue = love.graphics.newFont('fnt_main.ttf', 12)
    fnt_small = love.graphics.newFont('fnt_small.ttf', 8)
    img_select = love.graphics.newImage('menu/soul_small.png')
    img_flower = love.graphics.newImage('dream/flower.png')
    snd_menu = love.audio.newSource('snd_menu.wav', 'stream')

    fpsGraph = debugGraph:new('fps', 0, 0)
    memGraph = debugGraph:new('mem', 0, 30)
    gtGraph = debugGraph:new('custom', 0, 60)

    -- for testing, go to battle

    setBattle("flowey.beginning")

    gt = 0 -- game time
    math.randomseed(os.time())
end

function love.update(dt)
    input:update()
    Timer.update(dt)
    if dt >= 1 then gt = 0.000001
    else gt = dt end
    idleTimer = idleTimer + gt
    if gameState ~= "battle" then
        gs[gameState].update(gt)
    else
        if battleState:startsWith("flowey") then
            bs["flowey"][battleState:split(".")[2]].update(gt)
        else
            bs[battleState].update(gt)
        end
    end
    if input:pressed("select") then love.event.quit() end

    fpsGraph:update(dt)
    memGraph:update(dt)
    gtGraph:update(dt, math.floor(gt * 1000))
    gtGraph.label = 'GT: ' ..  math.round(gt, 4)
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
    if gameState ~= "battle" and gs ~= nil then
        gs[gameState].draw(screen)
    else
        if battleState:startsWith("flowey") then
            bs["flowey"][battleState:split(".")[2]].draw(screen)
        else
            bs[battleState].draw(screen)
        end
    end

    love.graphics.push()
        love.graphics.scale(1.25, 1.25)
        fpsGraph:draw()
        memGraph:draw()
        gtGraph:draw()
    love.graphics.pop()
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