local QBCore = exports['qb-core']:GetCoreObject()
local playerGang = ""
local playerJob = ""
local currentWeapon = nil

-- Update player data
local function UpdatePlayerData()
    QBCore.Functions.GetPlayerData(function(data)
        playerGang = string.lower(data.gang.name or "")
        playerJob = string.lower(data.job.name or "")
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    UpdatePlayerData()
    CheckWeaponRestrictions() -- Check on player load
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    playerGang = string.lower(gang.name or "")
    CheckWeaponRestrictions() -- Check on gang change
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    playerJob = string.lower(job.name or "")
    CheckWeaponRestrictions() -- Check on job change
end)

-- Gang check
local function IsPlayerGangAllowed()
    for _, gang in pairs(Config.AllowedGangs) do
        if playerGang == string.lower(gang) then return true end
    end
    return false
end

-- Police check
local function IsPlayerPolice()
    return playerJob == "police"
end

-- Weapon restriction check
function CheckWeaponRestrictions()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)

    if weapon == currentWeapon and weapon ~= 0 then return end
    currentWeapon = weapon

    for _, rifle in pairs(Config.AssaultRifles) do
        if weapon == GetHashKey(rifle) and not IsPlayerGangAllowed() then
            RemoveWeaponFromPed(ped, weapon)
            QBCore.Functions.Notify("You're not allowed to use assault rifles!", "error")
            TriggerServerEvent('gang_weapon_control:logViolation', GetPlayerServerId(PlayerId()), weapon, "GANG_RESTRICTED")
            return
        end
    end

    for _, pweapon in pairs(Config.PoliceWeapons) do
        if weapon == GetHashKey(pweapon) and not IsPlayerPolice() then
            RemoveWeaponFromPed(ped, weapon)
            QBCore.Functions.Notify("This weapon is restricted to police only!", "error")
            TriggerServerEvent('gang_weapon_control:logViolation', GetPlayerServerId(PlayerId()), weapon, "POLICE_RESTRICTED")
            return
        end
    end
end

-- Poll for weapon switches
CreateThread(function()
    while true do
        Wait(500)
        CheckWeaponRestrictions()
    end
end)
