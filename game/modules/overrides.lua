-- Math function overrides
function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end
function math.round(n, deci)
    deci = 10^(deci or 0)
    return math.floor(n*deci+.5)/deci
end
function math.clamp(x, min, max)
    return x < min and min or x > max and max or x
end
function math.lerp(a, b, t)
    return a + (b - a) * t
end

-- String function overrides
function string.startsWith(str, start)
    return str:sub(1, #start) == start
end

function string.endsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

function string.split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c)
        fields[#fields + 1] = c
    end)
    return fields
end

-- love function overrides
local oni = love.graphics.newImage
function love.graphics.newImage(path)
    path = "assets/images/" .. path
    return oni(path)
end
local ona = love.audio.newSource
function love.audio.newSource(path, type)
    -- check if it exists in sounds, else go to music folder
    if love.filesystem.getInfo("assets/sounds/" .. path) then
        path = "assets/sounds/" .. path
    else
        path = "assets/music/" .. path
    end

    return ona(path, type)
end
local onf = love.graphics.newFont
function love.graphics.newFont(path, size)
    if type(path) == "number" then
        size = path
        path = "fnt_main.ttf"
    end
    path = "assets/fonts/" .. path
    return onf(path, size)
end

if love.system.getOS then
    if love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X" then
        love._fps_cap = 60

        love.run = love.system.getOS() ~= "NX" and function()
            if love.math then
                love.math.setRandomSeed(os.time())
            end

            if love.event then
                love.event.pump()
            end

            if love.load then love.load(arg) end

            -- We don't want the first frame's dt to include time taken by love.load.
            if love.timer then love.timer.step() end

            local dt = 0

            -- Main loop time.
            while true do
                local m1 = love.timer.getTime() -- measure the time at the beginning of the main iteration
                -- Process events.
                if love.event then
                    love.event.pump()
                    for e,a,b,c,d in love.event.poll() do
                        if e == "quit" then
                            if not love.quit or not love.quit() then
                                if love.audio then
                                    love.audio.stop()
                                end
                                return
                            end
                        end
                        love.handlers[e](a,b,c,d)
                    end
                end

                -- Update dt, as we'll be passing it to update
                if love.timer then
                    love.timer.step()
                    dt = love.timer.getDelta()
                end

                -- Call update and draw
                if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

                if love.window and love.graphics and love.window.isOpen() then
                    love.graphics.clear()
                    love.graphics.origin()
                    if love.draw then love.draw() end
                    love.graphics.present()
                end
                local delta1 = love.timer.getTime() - m1 -- measure the time at the end of the main iteration and calculate delta
                if love.timer then love.timer.sleep(1/love._fps_cap-delta1) end
            end
        end

        function love.setFpsCap(fps)
            love._fps_cap = fps or 60
        end
    end
end