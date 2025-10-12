# L-weapons
Gang weapon & melee control for QBCore

> **Resource name:** `L-weapons`  
> **Author:** L.cts  
> **Version:** 1.2.0  
> **Framework:** QBCore (FiveM)  
> **Game:** GTA V

---

## ✨ Features

- **Gang‑gated assault rifles** — only gangs you whitelist can equip/use configured assault rifles (case‑insensitive gang names).
- **Police‑only weapons** — restrict taser / carbine Mk2 (and any others you list) to police job only.
- **Melee control** — block GTA melee *finishers* by default, or toggle to disable **all** melee entirely.
- **Live checks** — player load & weapon‑switch polling to immediately enforce rules.
- **Discord logging** — violations are posted to a webhook with player, CID, weapon and reason.
- **Lightweight** — client runs a short interval check; no DB required.

---

## 📦 Files

```
L-weapons/
├─ fxmanifest.lua
├─ client/
│  └─ client.lua
├─ server/
│  └─ server.lua
└─ shared/
   └─ config.lua
```

- `fxmanifest.lua` — resource meta (cerulean).  
- `client/client.lua` — detects player gang/job and enforces weapon/melee restrictions.  
- `server/server.lua` — logs violations to console and optional Discord webhook.  
- `shared/config.lua` — all configuration (gang list, weapon lists, melee toggle, webhook).

---

## ✅ Requirements

- **QBCore** (exports `qb-core`), with standard player data: `PlayerData.job.name` and `PlayerData.gang.name`.

No other dependencies are required.

---

## 🔧 Installation

1. **Place the resource**
   - Put this folder in your server resources: `resources/[local]/L-weapons` (keep the inner folder name `L-weapons`).

2. **Ensure the resource**
   - In your `server.cfg`, after QBCore:
     ```cfg
     ensure qb-core
     ensure L-weapons
     ```

3. **Configure**
   - Open `shared/config.lua` and adjust:
     - `Config.DisableAllMelee` — `false` (default) blocks only finishers; set `true` to block *all* melee.
     - `Config.AllowedGangs` — list of gang names allowed to use **assault rifles**.
       - **Case‑insensitive**. Examples: `"ballas"`, `"families"`, `"Triads"`, `"Cartel"`, `"mafia"`
     - `Config.AssaultRifles` — list of weapon names treated as *gang‑restricted rifles*.
     - `Config.PoliceWeapons` — list of weapon names *police‑only*.
     - `Config.Webhook` — Discord webhook URL for violation logs (or set to `nil`/empty to disable).

> Tip: weapon names must be the GTA weapon identifiers (e.g. `WEAPON_CARBINERIFLE_MK2`). Case is not important in config, but keep the correct hash name.

---

## 🧠 How it works

- On **player load** and every **~0.5s**, the client checks:
  - Current **weapon hash**.
  - Player **gang** and **job** from QBCore.
- If a player **doesn’t meet rules** (e.g., non‑gang holding an assault rifle, non‑police with police‑only weapon, melee disabled):
  - The script **blocks usage** (prevent aim/shoot/swing) and may **clear** the weapon from hands.
  - A violation is **sent to the server** → **printed** to console and **posted to Discord** (if webhook is set).
- Melee logic:
  - With `DisableAllMelee = false` (default), **melee finishers** are prevented while regular punches are allowed.
  - With `DisableAllMelee = true`, **all melee** actions are disabled.

---

## 🧩 Configuration Reference (`shared/config.lua`)

```lua
Config = {}

-- Melee settings
Config.DisableAllMelee = false  -- true: disable ALL melee; false: disable only finishers

-- Gangs allowed to use assault rifles (case-insensitive)
Config.AllowedGangs = {
    "ballas",
    "families",
    "vagos",
    "Triads",
    "Cartel",
    "mafia"
}

-- Assault rifles restricted to gangs
Config.AssaultRifles = {
    -- Examples (add/remove as needed):
    -- "WEAPON_ASSAULTRIFLE",
    -- "WEAPON_CARBINERIFLE",
    -- "WEAPON_CARBINERIFLE_MK2",
    -- "WEAPON_SPECIALCARBINE",
    -- "WEAPON_BULLPUPRIFLE",
    -- "WEAPON_ADVANCEDRIFLE",
    -- "WEAPON_COMPACTRIFLE",
}

-- Weapons restricted to police only
Config.PoliceWeapons = {
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_STUNGUN",
    "HANDCUFF",
    "BADGE",
}

-- Webhook for logging (set to nil or "" to disable)
Config.Webhook = ""
```

> **Note:** The example weapon lists above illustrate typical names; your actual file may already contain your custom lists. Keep the format the same.

---

## 🛡️ Jobs & Gangs

- **Police check:** `playerJob == "police"` (lower‑cased) — adjust your logic if your police job name differs.
- **Gangs:** read from `PlayerData.gang.name` and matched **case‑insensitively** against `Config.AllowedGangs`.

If your server uses different job/gang naming, just update your config (or the checks) accordingly.

---

## 📝 Logging format

Server prints and Discord messages include:
```
[WEAPON VIOLATION] PlayerName (CID | ID) tried to use WEAPON_NAME. Reason: <reason>
```
This helps you audit abuse attempts and confirm the rules are being enforced.

---

## 🔍 Troubleshooting

- **“My police can’t use their taser/rifle”**  
  Ensure their `job.name` is `"police"` (or modify the check) and the weapon is listed under `Config.PoliceWeapons`.

- **“Gangs still can’t hold rifles”**  
  Make sure the gang’s **name** in `Config.AllowedGangs` matches your QBCore gang name (case doesn’t matter).

- **“Logs aren’t appearing in Discord”**  
  Verify `Config.Webhook` is set to a valid Discord webhook URL. Set it to `nil` or `""` to disable.

- **“All melee is disabled but I only wanted to remove finishers”**  
  Set `Config.DisableAllMelee = false` to allow regular punches while blocking finisher animations.

- **Resource order matters**  
  Ensure `qb-core` starts before `L-weapons` in your `server.cfg`.

---

## 🔐 Security notes

- The script includes **server‑side validation & logging**; do **not** trust only client‑side checks.
- Keep weapon lists **minimal** and **explicit**. Avoid catch‑all logic that could block unintended items.

---

## 📜 Changelog

**v1.2.0**  
- Added configurable **police‑only** weapon list.  
- Expanded gang list support with **case‑insensitive** matching.  
- Improved melee handling: option to disable **finishers only** or **all melee**.  
- Added richer **Discord logging** payloads.

---
