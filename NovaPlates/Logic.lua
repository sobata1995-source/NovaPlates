NovaPlates = {}
local N = NovaPlates
N.colors = {
    aggro = {1, .20, .28}, warning = {1, .77, .18},
    tank = {.16, .88, .51}, unknown = {.40, .53, .68},
    friendly = {.30, .68, .90}, cast = {.55, .39, 1},
    hostile = {.90, .28, .20}, neutral = {1, .82, .25},
}
-- Faction reaction is independent of threat. Native NPC colors work without
-- unit tokens, including when several visible mobs have the same name.
function N.Reaction(reaction, r, g, b)
    if reaction then
        if reaction <= 3 then return "hostile" end
        if reaction == 4 then return "neutral" end
        return "friendly"
    end
    if r > .95 and g > .95 and b < .05 then return "neutral" end
    if r > .95 and g < .05 and b < .05 then return "hostile" end
    if r < .05 and (g > .95 or b > .95) then return "friendly" end
    return "unknown"
end
-- No global UnitThreatSituation(player) fallback: it describes other mobs too.
function N.Threat(tanking, status, percent, victimIsPlayer, tankHolds, fallback, threshold)
    if tanking or victimIsPlayer or status == 2 or status == 3 then return "aggro" end
    if status == 1 or (percent and percent >= threshold) then return "warning" end
    if fallback == 2 or fallback == 3 then return "aggro" end
    if fallback == 1 then return "warning" end
    if tankHolds then return "tank" end
    return "unknown"
end
function N.GlowStatus(shown, r, g, b)
    if not shown or not r or r < .5 then return nil end
    if g < .1 then return 3 end
    if b < .1 then return 2 end
    return 1
end
function N.Remaining(expiry, now)
    local n = math.max(0, expiry - now)
    if n >= 60 then return string.format("%dm", math.ceil(n / 60)) end
    if n >= 10 then return tostring(math.ceil(n)) end
    return string.format("%.1f", n)
end
-- These are base PvP cooldown estimates, not server queries. Talents/reset
-- effects can change them. NPC timers must be configured for the encounter.
N.spells = {
    [1766] = 10, [6552] = 10, [72] = 12, [2139] = 24,
    [47528] = 10, [57994] = 6, [19503] = 30, [34490] = 20,
    [15487] = 45, [47476] = 120, [48792] = 120, [45438] = 300,
    [642] = 300, [31884] = 180, [31224] = 90, [46924] = 90,
    [42292] = 120, -- PvP trinket (base cooldown)
    [1953] = 15, [23920] = 10, [408] = 20, [44572] = 30,
    [22812] = 60, [51514] = 45, [20066] = 60, [10308] = 60,
    [1044] = 25, [30283] = 20,
    [49576] = 35, [48707] = 45, -- Death Grip, Anti-Magic Shell (base cooldowns)
}
-- Category labels describe the spell, not a currently active buff.
N.kinds = {
    [1766]="INT", [6552]="INT", [72]="INT", [2139]="INT", [47528]="INT", [57994]="INT",
    [19503]="CC", [34490]="INT", [15487]="INT", [47476]="INT",
    [48792]="DEF", [45438]="DEF", [642]="DEF", [31884]="BUR", [31224]="DEF", [46924]="BUR",
    [42292]="TR", [1953]="MOV", [23920]="DEF", [408]="CC", [44572]="CC", [22812]="DEF",
    [51514]="CC", [20066]="CC", [10308]="CC", [1044]="DEF", [30283]="CC",
    [49576]="CC", [48707]="DEF",
}
N.kindColors = {INT={1,.69,.18}, DEF={.25,.83,1}, BUR={1,.30,.35},
    CC={.76,.48,1}, TR={1,.89,.40}, MOV={.30,.88,.62}, CD={.62,.45,1}, RAC={.95,.65,.85}}
N.rankAliases = {[1020] = 642}
function N.IsPlateTexture(path)
    if type(path) ~= "string" then return false end
    path = string.lower(path):gsub("/", "\\"):gsub("%.blp$", "")
    return path == "interface\\tooltips\\nameplate-border" or
        path == "interface\\targetingframe\\ui-targetingframe-flash"
end
N.interrupts = { WARRIOR = 6552, ROGUE = 1766, MAGE = 2139,
    DEATHKNIGHT = 47528, SHAMAN = 57994, HUNTER = 34490,
    PRIEST = 15487, DRUID = 5211, PALADIN = 10308 }
-- Name matching is restricted to observed hostile PLAYERS, never NPCs.
-- Keep all GUID candidates so equal names fail closed instead of last-wins.
function N.PlayerGUID(actors, name, now)
    local found
    for guid, actor in pairs(actors) do
        if actor.name == name and now - actor.seen < 600 then
            if found and found ~= guid then return nil end
            found = guid
        end
    end
    return found
end
local nextOrder = 0
function N.Record(store, guid, id, duration, now, petGUID)
    if not guid or not id or not duration or duration <= 0 then return end
    nextOrder = nextOrder + 1
    store[guid] = store[guid] or {}
    store[guid][id] = { start = now, duration = duration, expiry = now + duration, order = nextOrder, pet = petGUID }
end
function N.FIFO(timers, now)
    local active = {}
    for id, timer in pairs(timers or {}) do
        if timer.expiry > now then active[#active + 1] = {id=id, timer=timer} end
    end
    table.sort(active, function(a,b) return a.timer.order < b.timer.order end)
    return active
end
function N.ApplyReset(store, guid, resetID)
    local timers = store[guid]
    if not timers then return end
    local prep = {[14177]=true, [36554]=true, [1856]=true, [5277]=true, [2983]=true}
    for id, timer in pairs(timers) do
        local m = N.spellMeta and N.spellMeta[id]
        local remove = false
        if m and not timer.pet and id ~= resetID then
            if resetID == 11958 then
                remove = m.family == 3 and math.floor(m.school / 16) % 2 == 1
            elseif resetID == 23989 then
                remove = m.family == 9 and id ~= 19574 and id ~= 59543
            elseif resetID == 14185 then remove = prep[id] end
        end
        if remove then timers[id] = nil end
    end
end
function N.Prune(store, now)
    for guid, spells in pairs(store) do
        for id, timer in pairs(spells) do
            if timer.expiry <= now then spells[id] = nil end
        end
        if not next(spells) then store[guid] = nil end
    end
end
