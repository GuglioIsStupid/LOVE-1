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
