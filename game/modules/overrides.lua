-- Math function overrides
function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end
function math.round(x)
    return math.floor(x + 0.5)
end
function math.clamp(x, min, max)
    return x < min and min or x > max and max or x
end
function math.lerp(a, b, t)
    return a + (b - a) * t
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
    path = "assets/fonts/" .. path
    return onf(path, size)
end