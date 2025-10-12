Config = {}

-- Melee settings
Config.DisableAllMelee = false -- true disables all melee, false disables only finishers

-- Gangs allowed to use assault rifles (case-insensitive)
Config.AllowedGangs = {
    "ballas",
    "families",
    "vagos",
    "Triads",
    "Cartel", -- custom gang names
    "mafia"
}

-- Assault rifles restricted to gangs
Config.AssaultRifles = {
    "weapon_assaultrifle_mk2",
    -- "WEAPON_CARBINERIFLE",
    -- "WEAPON_ADVANCEDRIFLE",
    -- "WEAPON_SPECIALCARBINE",
    -- "WEAPON_BULLPUPRIFLE",
    -- "WEAPON_COMPACTRIFLE",
}

-- Weapons restricted to police only
Config.PoliceWeapons = {
    "weapon_carbinerifle_mk2",
    "weapon_stungun",
    "handcuff",
    "badge",
    
}

-- Webhook for logging (set to nil to disable)
Config.Webhook = "https://discord.com/api/webhooks/1371263645409087588/W1yGEE1qpy240RjFDYLub2dpgYhlhjp8aSfG4nLVt3JF19HJg5U9eKQTCXBjYgjp2r8x"
