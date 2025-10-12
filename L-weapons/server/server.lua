local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('gang_weapon_control:logViolation', function(playerId, weaponHash, reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local weaponName = GetWeaponNameFromHash(weaponHash)
    local msg = string.format("[WEAPON VIOLATION] %s (%s | %s) tried to use %s. Reason: %s",
        Player.PlayerData.name, Player.PlayerData.citizenid, Player.PlayerData.source, weaponName, reason)

    print(msg)

    if Config.Webhook and Config.Webhook ~= "" then
        PerformHttpRequest(Config.Webhook, function() end, "POST", json.encode({
            username = "Weapon Control Logger",
            embeds = {{
                title = "Weapon Violation Detected",
                description = msg,
                color = 15158332,
                footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
            }}
        }), { ["Content-Type"] = "application/json" })
    end
end)

function GetWeaponNameFromHash(hash)
    for _, name in pairs(Config.AssaultRifles) do
        if GetHashKey(name) == hash then return name end
    end
    for _, name in pairs(Config.PoliceWeapons) do
        if GetHashKey(name) == hash then return name end
    end
    return "Unknown Weapon"
end
