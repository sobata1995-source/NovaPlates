local addon = CreateFrame("Frame")
local plates, hooked, pending = {}, false, false
local db
local colors = {
    aggro = {1, .16, .22}, warning = {1, .80, .12}, tank = {.15, .88, .43},
    hostile = {.86, .28, .12}, neutral = {1, .83, .25}, friendly = {.30, .70, .95},
}
-- Check secrets BEFORE comparisons, concatenation or table lookup.
local function readable(value)
    return not (issecretvalue and issecretvalue(value))
end
local function read(fn, ...)
    if type(fn) ~= "function" then return nil, false end
    local ok, value = pcall(fn, ...)
    if not ok or not readable(value) then return nil, false end
    return value, true
end
local function say(text) print("|cff68cfffNovaPlates Forever:|r " .. text) end
local function state(unit)
    local player, ok = read(UnitIsPlayer, unit)
    if not ok or player then return nil end -- Preserve Blizzard player/class colors.
    local dead, deadOK = read(UnitIsDeadOrGhost, unit)
    if not deadOK or dead then return nil end
    local denied = read(UnitIsTapDenied, unit)
    if denied then return nil end
    local reaction, reactionOK = read(UnitReaction, unit, "player")
    if not reactionOK or not reaction then return nil end
    if reaction > 4 then return "friendly" end
    local threat, threatOK = read(UnitThreatSituation, "player", unit)
    if not threatOK then return nil end -- Native colors when threat is restricted.
    if threat == 2 or threat == 3 then return "aggro" end
    if threat == 1 then return "warning" end
    local victim = unit .. "target"
    local fighting, fightingOK = read(UnitAffectingCombat, unit)
    if not fightingOK then return nil end
    if fighting then
        local selfTarget = read(UnitIsUnit, victim, "player")
        if selfTarget then return "aggro" end
        local guid = read(UnitGUID, victim)
        if db.tankGUID and guid and guid == db.tankGUID then return "tank" end
        local role = read(UnitGroupRolesAssigned, victim)
        local group = read(UnitInParty, victim)
        local raid = read(UnitInRaid, victim)
        if role == "TANK" and (group or raid) then return "tank" end
    end
    return reaction == 4 and "neutral" or "hostile"
end
local function paint(frame)
    if not db or not db.enabled then return end
    local unit = plates[frame]
    if not unit or frame:IsForbidden() or not frame.healthBar then return end
    local key = state(unit)
    local color = key and colors[key]
    if color then frame.healthBar:SetStatusBarColor(unpack(color)) end
end
local function attach(unit)
    if not readable(unit) or type(unit) ~= "string" then return end
    if not C_NamePlate or not C_NamePlate.GetNamePlateForUnit then return end
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate or plate:IsForbidden() then return end
    local frame = plate.UnitFrame
    if not frame or frame:IsForbidden() then return end
    plates[frame] = unit
    if CompactUnitFrame_UpdateHealthColor then CompactUnitFrame_UpdateHealthColor(frame) end
end
local function installHook()
    if not hooked and type(CompactUnitFrame_UpdateHealthColor) == "function" then
        hooksecurefunc("CompactUnitFrame_UpdateHealthColor", paint)
        hooked = true
    end
end
local preset = {nameplateShowEnemies="1", nameplateStyle="1", nameplateSize="1", nameplateStackingTypes="1", nameplateThreatDisplay="3"}
local function settings(restore)
    if InCombatLockdown() then pending = restore and "restore" or "apply"; return end
    pending = false
    for key, value in pairs(restore and db.previous or preset) do
        local current = C_CVar.GetCVar(key)
        if current ~= nil then
            if not restore and db.previous[key] == nil then db.previous[key] = current end
            C_CVar.SetCVar(key, value)
        end
    end
end
addon:SetScript("OnEvent", function(_, event, unit)
    if event == "PLAYER_LOGIN" then
        NovaPlatesForeverDB = NovaPlatesForeverDB or {}
        db = NovaPlatesForeverDB
        db.previous = db.previous or {}
        if db.enabled == nil then db.enabled = true end
        installHook()
        if db.enabled then settings(false) end
        if C_NamePlate and C_NamePlate.GetNamePlates then
            for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
                if not plate:IsForbidden() then attach(plate.namePlateUnitToken or plate.unitToken) end
            end
        end
        say("0.1.0 alpha loaded. /np help | Cooldowns disabled.")
    elseif event == "ADDON_LOADED" then
        installHook()
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        attach(unit)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        if readable(unit) then
            for frame, token in pairs(plates) do if token == unit then plates[frame] = nil end end
        end
    elseif event == "PLAYER_REGEN_ENABLED" and pending and db then
        settings(pending == "restore")
    end
end)
for _, event in ipairs({"PLAYER_LOGIN", "ADDON_LOADED", "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "PLAYER_REGEN_ENABLED"}) do addon:RegisterEvent(event) end
local elapsed = 0
addon:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < .2 or not db then return end
    elapsed = 0
    for frame in pairs(plates) do
        if not frame:IsForbidden() and frame:IsShown() and CompactUnitFrame_UpdateHealthColor then
            -- Recompute the native color first, so secret/unknown/dead states never keep stale custom colors.
            CompactUnitFrame_UpdateHealthColor(frame)
        end
    end
end)
SLASH_NOVAPLATESFOREVER1 = "/np"
SlashCmdList.NOVAPLATESFOREVER = function(message)
    if not db then return end
    message = (message or ""):lower():match("^%s*(.-)%s*$")
    if message == "tank" then
        local friendly = read(UnitIsFriend, "player", "target")
        local player = read(UnitIsPlayer, "target")
        local guid = read(UnitGUID, "target")
        if friendly and player and guid then db.tankGUID = guid; say("Selected tank saved.")
        else say("Select a friendly player, then /np tank.") end
    elseif message == "tank clear" then
        db.tankGUID = nil; say("Manual tank cleared; group tank roles remain active.")
    elseif message == "restore" then
        db.enabled = false; settings(true); say("Original settings restored (after combat if necessary).")
    elseif message == "compact" or message == "on" then
        db.enabled = true; settings(false); say("Compact plates enabled (after combat if necessary).")
    elseif message == "status" then
        local count = 0; for _ in pairs(plates) do count = count + 1 end
        say("0.1.0 alpha | plates=" .. count .. " | enabled=" .. tostring(db.enabled) .. " | color hook=" .. tostring(hooked) .. " | cooldowns=OFF")
    else
        say("/np compact | /np tank (friendly target) | /np tank clear | /np restore | /np status")
        say("Red: your aggro; yellow: high threat; green: tank target. Orange-red: hostile NPC; gold: neutral NPC. Restricted data: Blizzard colors.")
    end
end
