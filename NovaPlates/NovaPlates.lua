local N = NovaPlates
local WHITE = "Interface\\Buttons\\WHITE8X8"
local FONT = STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
local plates, cooldowns, tanks, units = {}, {}, {}, {}
local actors, spellNames = {}, {}
local petOwners = {}
local attackablePlayers = {}
local stats = { observed = 0, tracked = 0, last = "none", raw = 0, paladin = "none" }
local db, preview, interruptName, interruptTexture
local controller = CreateFrame("Frame")
local defaults = { width = 150, height = 12, scale = .9, threshold = 85,
    enemy = true, interrupt = true, custom = {} }
local function Say(s) DEFAULT_CHAT_FRAME:AddMessage("|cff8d77ffNovaPlates:|r " .. s) end
local function Text(parent, size)
    local t = parent:CreateFontString(nil, "OVERLAY")
    t:SetFont(FONT, size, "OUTLINE")
    t:SetShadowOffset(1, -1)
    return t
end
local function Backdrop(f, r, g, b)
    f:SetBackdrop({bgFile = WHITE, edgeFile = WHITE, edgeSize = 1,
        insets = {left = 1, right = 1, top = 1, bottom = 1}})
    f:SetBackdropColor(.025, .033, .055, .96)
    f:SetBackdropBorderColor(r or .15, g or .19, b or .27, 1)
end
local function Bar(parent, height)
    local b = CreateFrame("StatusBar", nil, parent)
    b:SetHeight(height)
    b:SetStatusBarTexture(WHITE)
    b:SetMinMaxValues(0, 1)
    b.bg = b:CreateTexture(nil, "BACKGROUND")
    b.bg:SetAllPoints()
    b.bg:SetTexture(.035, .045, .065, 1)
    return b
end
local function Icon(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetWidth(24); f:SetHeight(24); f:EnableMouse(false)
    Backdrop(f, .55, .39, 1)
    f.tex = f:CreateTexture(nil, "ARTWORK")
    f.tex:SetPoint("TOPLEFT", 2, -2); f.tex:SetPoint("BOTTOMRIGHT", -2, 2)
    f.tex:SetTexCoord(.08, .92, .08, .92)
    f.shade = f:CreateTexture(nil, "OVERLAY")
    f.shade:SetAllPoints(f.tex); f.shade:SetTexture(0, 0, 0, .32)
    f.time = Text(f, 11); f.time:SetPoint("CENTER")
    f.progress = Bar(f, 2)
    f.progress:SetPoint("BOTTOMLEFT", 2, 2); f.progress:SetPoint("BOTTOMRIGHT", -2, 2)
    f.progress:SetStatusBarColor(.62, .45, 1)
    f.tag = Text(f, 8); f.tag:SetPoint("TOP", f, "BOTTOM", 0, -1)
    f:Hide()
    return f
end
local function MakeVisual(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:EnableMouse(false)
    f:SetFrameLevel(parent:GetFrameLevel() + 5)
    f:SetWidth(db.width + 4); f:SetHeight(db.height + 4)
    Backdrop(f)
    f.health = Bar(f, db.height)
    f.health:SetPoint("TOPLEFT", 2, -2); f.health:SetPoint("BOTTOMRIGHT", -2, 2)
    f.health:SetValue(1)
    f.shine = f.health:CreateTexture(nil, "OVERLAY")
    f.shine:SetPoint("TOPLEFT"); f.shine:SetPoint("TOPRIGHT"); f.shine:SetHeight(1)
    f.shine:SetTexture(1, 1, 1, .22)
    -- Text on a higher frame so statusbar fill never covers it.
    f.textLayer = CreateFrame("Frame", nil, f.health)
    f.textLayer:SetAllPoints(); f.textLayer:EnableMouse(false)
    f.name = Text(f.textLayer, 11)
    f.name:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 5)
    f.name:SetWidth(db.width - 25); f.name:SetJustifyH("LEFT")
    f.level = Text(f.textLayer, 10); f.level:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 0, 5)
    f.percent = Text(f.textLayer, 9); f.percent:SetPoint("RIGHT", -4, 0)
    f.state = Text(f.textLayer, 8); f.state:SetPoint("LEFT", 4, 0)
    f.cast = Bar(f, 9)
    f.cast:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 2, -4)
    f.cast:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", -2, -4)
    f.cast.label = Text(f.cast, 9); f.cast.label:SetPoint("LEFT", 3, 0)
    f.cast.label:SetWidth(db.width - 42); f.cast.label:SetJustifyH("LEFT")
    f.cast.time = Text(f.cast, 9); f.cast.time:SetPoint("RIGHT", -3, 0)
    f.cast:Hide()
    f.marker = f:CreateTexture(nil, "OVERLAY")
    f.marker:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    f.marker:SetWidth(22); f.marker:SetHeight(22)
    f.marker:SetPoint("RIGHT", f, "LEFT", -5, 0); f.marker:Hide()
    f.icons = {}
    for i = 1, 5 do
        f.icons[i] = Icon(f)
        f.icons[i]:SetPoint("BOTTOMLEFT", f, "TOPLEFT", (i - 1) * 28, 23)
        f.icons[i].tag:SetText("~CD")
    end
    f.overflow = Text(f, 10)
    f.overflow:SetPoint("LEFT", f.icons[5], "RIGHT", 3, 0)
    f.overflow:Hide()
    f.kick = Icon(f)
    f.kick:SetPoint("LEFT", f, "RIGHT", 7, 0)
    f.kick.tag:SetText("YOU")
    return f
end
local function Layout(f)
    f:SetWidth(db.width + 4); f:SetHeight(db.height + 4); f:SetScale(db.scale)
    f.name:SetWidth(db.width - 25); f.cast.label:SetWidth(db.width - 42)
end
local function InitializeDB()
    NovaPlatesDB = type(NovaPlatesDB) == "table" and NovaPlatesDB or {}
    db = NovaPlatesDB
    -- Always enable enemy cooldowns on login/reload, including old saved OFF.
    -- /np enemy off remains available for the current session.
    db.enemy = true
    for k, v in pairs(defaults) do
        if db[k] == nil then db[k] = type(v) == "table" and {} or v end
    end
    -- Apply the requested compact layout once when upgrading; later manual
    -- size changes survive reloads. Other saved preferences are preserved.
    if not db.compactV1 then
        db.width, db.height, db.scale, db.compactV1 = 150, 12, .9, true
    end
    db.width = math.max(120, math.min(300, tonumber(db.width) or 180))
    db.height = math.max(10, math.min(30, tonumber(db.height) or 16))
    db.scale = math.max(.6, math.min(1.8, tonumber(db.scale) or 1))
    db.threshold = math.max(50, math.min(100, tonumber(db.threshold) or 85))
    if type(db.custom) ~= "table" then db.custom = {} end
end
local function FindInterrupt()
    interruptName, interruptTexture = nil, nil
    local _, class = UnitClass("player")
    local id = db.interruptID or N.interrupts[class]
    if not id then return end
    local wanted, _, tex = GetSpellInfo(id)
    if not wanted then return end
    for i = 1, 1024 do
        local name = GetSpellName(i, BOOKTYPE_SPELL or "spell")
        if not name then break end
        if name == wanted then interruptName, interruptTexture = name, tex; break end
    end
end
local function RebuildUnits()
    wipe(units); wipe(tanks)
    local function Add(u)
        if UnitExists(u) then
            units[#units + 1] = u
            if UnitIsPlayer(u) and UnitCanAttack("player", u) then
                local guid, name = UnitGUID(u), UnitName(u)
                if guid and name then
                    local actor = actors[guid] or {}
                    local _, class = UnitClass(u)
                    actor.name, actor.seen, actor.hostile, actor.class = name, GetTime(), true, class
                    actors[guid] = actor
                    attackablePlayers[guid] = true
                end
            end
        end
    end
    Add("target"); Add("mouseover"); Add("focus")
    local members = {"player"}
    for i = 1, GetNumPartyMembers() do members[#members + 1] = "party" .. i end
    for i = 1, GetNumRaidMembers() do members[#members + 1] = "raid" .. i end
    for _, u in ipairs(members) do
        local guid = UnitGUID(u)
        local name = UnitName(u)
        if guid and ((db.tankName and name == db.tankName) or
            (GetPartyAssignment and GetPartyAssignment("MAINTANK", u))) then tanks[guid] = true end
        Add(u .. "target")
    end
    for i = 1, 5 do Add("arena" .. i) end
    local function LinkPet(owner, pet)
        local ownerGUID, petGUID = UnitGUID(owner), UnitGUID(pet)
        if ownerGUID and petGUID and UnitIsPlayer(owner) then petOwners[petGUID] = ownerGUID end
    end
    for i = 1, 5 do LinkPet("arena" .. i, "arenapet" .. i) end
    for i = 1, GetNumPartyMembers() do LinkPet("party" .. i, "partypet" .. i) end
    for i = 1, GetNumRaidMembers() do LinkPet("raid" .. i, "raidpet" .. i) end
end
local function MarkerIndex(region)
    if not region or not region:IsShown() then return nil end
    local left, _, top = region:GetTexCoord()
    -- Texture:GetTexCoord returns 8 coordinates on the legacy client.
    local a,b,c,d,e,f,g,h = region:GetTexCoord()
    if e then left, top = a, b else left, top = a, c end
    return math.floor(left * 4 + .5) + math.floor(top * 4 + .5) * 4 + 1
end
local function Resolve(p)
    local name = p.regions[7]:GetText()
    if not name then return nil end
    -- Native alpha identifies the selected plate; native highlight identifies
    -- mouseover. Do not bind equal-name mobs by name alone.
    if UnitExists("target") and UnitName("target") == name and p.native:GetAlpha() > .99 then
        local count = 0
        for _, q in pairs(plates) do
            if q.native:IsShown() and q.native:GetAlpha() > .99 and q.regions[7]:GetText() == name then count = count + 1 end
        end
        if count == 1 then return "target" end
    end
    if p.regions[6] and p.regions[6]:IsShown() and UnitName("mouseover") == name then return "mouseover" end
    local marker = MarkerIndex(p.regions[10])
    if marker then
        for _, u in ipairs(units) do
            if UnitName(u) == name and GetRaidTargetIndex(u) == marker then return u end
        end
    end
    -- A player remains identifiable after target/mouseover changes. Require
    -- one visible plate and one observed hostile player GUID for that name.
    local guid = N.PlayerGUID(actors, name, GetTime())
    if guid then
        local count = 0
        for _, q in pairs(plates) do
            if q.native:IsShown() and q.regions[7]:GetText() == name then count = count + 1 end
        end
        if count == 1 then
            for _, unit in ipairs(units) do
                if UnitGUID(unit) == guid then return unit, guid end
            end
            return nil, guid
        end
    end
end
local labels = {aggro = "AGGRO", warning = "HIGH THREAT", tank = "TANK", unknown = "", friendly = "", hostile = "HOSTILE", neutral = "NEUTRAL"}
local function Paint(f, state, now, selected)
    local c = N.colors[state]
    f.health:SetStatusBarColor(c[1], c[2], c[3])
    f.state:SetText(labels[state])
    local a = state == "aggro" and (.6 + .4 * math.abs(math.sin(now * 4))) or .65
    if selected then f:SetBackdropBorderColor(1, 1, 1, .95)
    else f:SetBackdropBorderColor(c[1], c[2], c[3], a) end
end
local function UpdateCast(p, u, now)
    local c = p.visual.cast
    local name, _, _, _, startMS, endMS, _, _, locked
    local channel
    if u then
        name, _, _, _, startMS, endMS, _, _, locked = UnitCastingInfo(u)
        if not name then
            name, _, _, _, startMS, endMS, _, locked = UnitChannelInfo(u)
            channel = name ~= nil
        end
    end
    if name and startMS and endMS and endMS > startMS then
        c:SetMinMaxValues(0, (endMS - startMS) / 1000)
        c:SetValue(channel and (endMS / 1000 - now) or (now - startMS / 1000))
        c.label:SetText((locked and "[X] " or "") .. name)
        c.time:SetText(string.format("%.1f", math.max(0, endMS / 1000 - now)))
        if locked then c:SetStatusBarColor(.45, .48, .55) else c:SetStatusBarColor(.55, .39, 1) end
        c:Show()
    elseif p.cast and p.cast:IsShown() then
        c:SetMinMaxValues(p.cast:GetMinMaxValues()); c:SetValue(p.cast:GetValue())
        c.label:SetText("CAST"); c.time:SetText("")
        c:SetStatusBarColor(.55, .39, 1); c:Show()
    else c:Hide() end
end
local function UpdateIcons(f, guid, now, selected)
    local active = {}
    if db.enemy and guid and cooldowns[guid] then
        active = N.FIFO(cooldowns[guid], now)
    end
    if #active > #f.icons then f.overflow:SetText("+" .. (#active - #f.icons)); f.overflow:Show()
    else f.overflow:Hide() end
    for i, icon in ipairs(f.icons) do
        local item = active[i]
        if item then
            local _, _, tex = GetSpellInfo(item.id)
            icon.tex:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")
            icon.time:SetText(N.Remaining(item.timer.expiry, now))
            icon.progress:SetValue((item.timer.expiry - now) / item.timer.duration)
            local kind = N.kinds[item.id] or "CD"
            local color = N.kindColors[kind]
            icon.tag:SetText(item.timer.pet and "~PET" or ("~" .. kind))
            icon:SetBackdropBorderColor(color[1], color[2], color[3], 1)
            icon.progress:SetStatusBarColor(color[1], color[2], color[3])
            local a = item.timer.expiry - now < 3 and (.5 + .5 * math.abs(math.sin(now * 6))) or 1
            icon:SetAlpha(a); icon:Show()
        else icon:Hide() end
    end
    local k = f.kick
    if db.interrupt and selected and interruptName then
        local start, duration, enabled = GetSpellCooldown(interruptName)
        k.tex:SetTexture(interruptTexture)
        if enabled == 0 then
            k.time:SetText("OFF"); k.progress:SetValue(0)
        elseif start and duration and duration > 1.5 and start + duration > now then
            k.time:SetText(N.Remaining(start + duration, now)); k.progress:SetValue((start + duration - now) / duration)
        else k.time:SetText("RDY"); k.progress:SetValue(1) end
        k:Show()
    else k:Hide() end
end
local function UpdatePlate(p, now, elapsed)
    local f = p.visual
    local u, playerGUID = Resolve(p)
    local guid = (u and UnitGUID(u)) or playerGUID
    local name = p.regions[7]:GetText() or ""
    -- NPC GUIDs still require a live identity signal; player names use actors.
    local selected = u and UnitIsUnit(u, "target")
    f.name:SetText(name)
    f.level:SetText(p.regions[9] and p.regions[9]:IsShown() and "??" or (p.regions[8]:GetText() or ""))
    local lo, hi = p.health:GetMinMaxValues()
    local value = p.health:GetValue()
    local ratio = hi > lo and math.max(0, math.min(1, (value - lo) / (hi - lo))) or 0
    if p.lastName ~= name or p.lastGUID ~= guid then f.health:SetValue(ratio) end
    p.lastName, p.lastGUID = name, guid
    f.health:SetValue(f.health:GetValue() + (ratio - f.health:GetValue()) * math.min(1, elapsed * 14))
    f.percent:SetText(math.floor(ratio * 100 + .5) .. "%")
    local r,g,b = p.health:GetStatusBarColor()
    local isPlayer = (u and UnitIsPlayer(u)) or (guid and actors[guid] ~= nil)
    local reaction = N.Reaction(u and UnitReaction(u, "player"), r, g, b)
    if not u and playerGUID and actors[playerGUID].hostile and reaction ~= "friendly" then reaction = "hostile" end
    local state = reaction
    local nameColor = N.colors[reaction]
    f.name:SetTextColor(nameColor[1], nameColor[2], nameColor[3])
    if reaction ~= "friendly" and not isPlayer then
        local isTanking, status, percent, tankHolds, victim
        if u and UnitAffectingCombat(u) then
            isTanking, status, percent = UnitDetailedThreatSituation("player", u)
            victim = UnitIsUnit(u .. "target", "player")
            local victimGUID = UnitGUID(u .. "target")
            tankHolds = victimGUID and tanks[victimGUID] and UnitAffectingCombat(u)
        end
        local glow = p.regions[1]
        local gr,gg,gb = glow:GetVertexColor()
        local fallback = UnitAffectingCombat("player") and N.GlowStatus(glow:IsShown(), gr,gg,gb)
        local threat = N.Threat(isTanking, status, percent, victim, tankHolds, fallback, db.threshold)
        if threat ~= "unknown" then state = threat end
    end
    Paint(f, state, now, selected)
    if isPlayer then
        local class
        if u then local _, unitClass = UnitClass(u); class = unitClass end
        class = class or (actors[guid] and actors[guid].class)
        local color = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if color then f.health:SetStatusBarColor(color.r, color.g, color.b) end
        -- The name/border retain reaction/selection while the fill shows class.
        if selected then f.state:SetText("TARGET")
        elseif reaction ~= "friendly" then f.state:SetText("PVP") end
    end
    if p.regions[10] and p.regions[10]:IsShown() then
        f.marker:SetTexCoord(p.regions[10]:GetTexCoord()); f.marker:Show()
    else f.marker:Hide() end
    -- Record player spells independently from reaction flags: same-faction
    -- duel casts can carry friendly flags. Gate display on the actual plate.
    -- Same-faction duel plates can retain friendly colors after losing target.
    -- Preserve verified attackability by GUID until the duel ends, never by name.
    if isPlayer and guid and u and UnitCanAttack("player", u) then attackablePlayers[guid] = true end
    local showCooldowns = reaction == "hostile" or (u and UnitCanAttack("player", u)) or
        (guid and attackablePlayers[guid])
    UpdateCast(p, u, now); UpdateIcons(f, isPlayer and showCooldowns and guid or nil, now, selected)
    -- Preserve native signals and values; only hide their artwork.
    p.health:SetAlpha(0)
    if p.cast then p.cast:SetAlpha(0) end
    for _, region in ipairs(p.regions) do region:SetAlpha(0) end
end
local function Discover()
    for _, native in ipairs({WorldFrame:GetChildren()}) do
        if not plates[native] then
            local regions = {native:GetRegions()}
            local plateTexture = false
            for _, region in ipairs(regions) do
                if region:GetObjectType() == "Texture" and N.IsPlateTexture(region:GetTexture()) then plateTexture = true; break end
            end
            if plateTexture then
                local health, cast = native:GetChildren()
                if health and health:GetObjectType() == "StatusBar" and regions[7] and regions[8] and
                    regions[7]:GetObjectType() == "FontString" and regions[8]:GetObjectType() == "FontString" then
                    local p = {native = native, regions = regions, health = health, cast = cast}
                    p.visual = MakeVisual(native)
                    p.visual:SetPoint("CENTER", health, "CENTER", 0, 0)
                    Layout(p.visual); plates[native] = p
                    native:HookScript("OnHide", function()
                        p.lastGUID, p.lastName = nil, nil
                        for _, icon in ipairs(p.visual.icons) do icon:Hide() end
                        p.visual.cast:Hide(); p.visual.kick:Hide()
                    end)
                end
            end
        end
    end
end
local defensiveAuras = {[45438] = true, [642] = true, [31884] = true, [48792] = true, [31224] = true, [46924] = true, [22812] = true, [1044] = true, [23920] = true, [48707] = true}
local function BuildSpellNames()
    wipe(spellNames)
    for id in pairs(N.spells) do
        local name = GetSpellInfo(id)
        local canonical = N.rankAliases[id] or id
        if name then
            if spellNames[name] == nil then spellNames[name] = canonical
            elseif spellNames[name] ~= canonical then spellNames[name] = false end
        end
    end
end
local function CombatLog(_, event, src, srcName, srcFlags, dst, dstName, dstFlags, id, spellName)
    stats.raw = stats.raw + 1
    local paladinEvent = id == 642 or id == 1020 or id == 31884
    if paladinEvent then stats.paladin = tostring(event) .. " id=" .. tostring(id) .. " flags=" .. tostring(srcFlags) end
    if event == "UNIT_DIED" or event == "UNIT_DESTROYED" then
        if dst then cooldowns[dst] = nil end
        local owner = dst and petOwners[dst]
        if owner and cooldowns[owner] then
            for spell, timer in pairs(cooldowns[owner]) do if timer.pet == dst then cooldowns[owner][spell] = nil end end
        end
        if dst then petOwners[dst] = nil end
        return
    end
    if event == "SPELL_SUMMON" and src and dst then
        if srcFlags and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER or 1024) ~= 0 then
            petOwners[dst] = src
            if srcName then
                local actor = actors[src] or {}
                actor.name, actor.seen = srcName, GetTime()
                actor.hostile = (bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE or 64) ~= 0) or actor.hostile
                actors[src] = actor
            end
        end
        -- Summon is useful for ownership, but only successful casts start CDs.
        return
    end
    if event ~= "SPELL_CAST_SUCCESS" and event ~= "SPELL_INTERRUPT" and event ~= "SPELL_AURA_APPLIED" then return end
    if not src or not id then return end
    local hostile = srcFlags and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE or 64) ~= 0
    local player = srcFlags and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER or 1024) ~= 0
    if not hostile then
        -- Duel opponents can have different reaction flags; use a current
        -- hostile unit token when available, never include friendly casts.
        for _, u in ipairs(units) do
            if UnitGUID(u) == src and UnitCanAttack("player", u) then
                hostile = true; player = UnitIsPlayer(u); break
            end
        end
    end
    -- Preserve observed player cooldowns regardless of faction. Friendly
    -- players' icons remain hidden by UpdatePlate's display filter.
    local owner = not player and petOwners[src]
    if not player and not owner then return end
    local timerGUID = owner or src
    if timerGUID == UnitGUID("player") then return end
    local now = GetTime()
    if player and srcName then
        local actor = actors[src] or {}
        actor.name, actor.seen, actor.hostile = srcName, now, hostile or actor.hostile
        actors[src] = actor
    end
    if event == "SPELL_CAST_SUCCESS" then
        stats.observed = stats.observed + 1
        stats.last = tostring(srcName) .. " / " .. tostring(id)
    end
    -- Different ranks share the localized spell name on this client.
    -- Restrict rank aliases to players; NPCs may reuse a player's spell name.
    local canonical = N.rankAliases[id] or spellNames[spellName or GetSpellInfo(id)]
    canonical = canonical or id
    local meta = N.spellMeta and N.spellMeta[canonical]
    if owner and (not meta or meta.actor ~= "pet") then return end
    if player and meta and meta.actor == "pet" then return end
    if event == "SPELL_CAST_SUCCESS" then N.ApplyReset(cooldowns, timerGUID, canonical) end
    local duration = db.custom[id]
    if duration == nil then duration = db.custom[canonical] end
    if duration == nil then duration = N.spells[id] or N.spells[canonical] end
    if not duration or duration <= 0 then
        if paladinEvent then stats.paladin = stats.paladin .. " timer=disabled" end
        return
    end
    if event == "SPELL_AURA_APPLIED" and (not defensiveAuras[canonical] or src ~= dst) then return end
    local old = cooldowns[timerGUID] and cooldowns[timerGUID][canonical]
    -- Cast + aura/interrupt events must not restart the same timer.
    if old and ((event == "SPELL_AURA_APPLIED" and old.expiry > now) or now - old.start < .5) then return end
    N.Record(cooldowns, timerGUID, canonical, duration, now, owner and src or nil)
    stats.tracked = stats.tracked + 1
    if paladinEvent then stats.paladin = stats.paladin .. " timer=recorded" end
end
local function Preview()
    if preview then
        if preview:IsShown() then preview:Hide() else preview:Show() end
        return
    end
    preview = CreateFrame("Frame", nil, UIParent)
    preview:SetWidth(620); preview:SetHeight(430)
    preview:SetPoint("CENTER"); preview:SetFrameStrata("DIALOG")
    Backdrop(preview, .55, .39, 1)
    preview:EnableMouse(true); preview:SetMovable(true)
    preview:RegisterForDrag("LeftButton")
    preview:SetScript("OnDragStart", function(self) self:StartMoving() end)
    preview:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    local title = Text(preview, 16); title:SetPoint("TOP", 0, -18); title:SetText("N O V A  /  P L A T E S")
    local sub = Text(preview, 10); sub:SetPoint("TOP", 0, -43); sub:SetText("PREVIEW  -  /np test to close")
    for i, state in ipairs({"tank", "warning", "aggro", "hostile", "hostile"}) do
        local f = MakeVisual(preview)
        local row = (i - 1) % 3
        f:SetPoint("TOP", i <= 3 and -145 or 145, -110 - row * 115)
        f.name:SetText(({"PvE / Tank holds", "PvE / Threat rising", "PvE / Attacking you", "PvP / Paladin", "PvP / Mage"})[i])
        f.level:SetText("83"); f.health:SetValue(.86 - i * .12)
        f.percent:SetText((86 - i * 12) .. "%")
        Paint(f, state, GetTime(), false)
        f.cast:Show(); f.cast:SetValue(.65); f.cast:SetStatusBarColor(.55, .39, 1)
        f.cast.label:SetText("Shadow Bolt"); f.cast.time:SetText("1.4")
        for j = 1, 3 do
            local icon = f.icons[j]
            local id = (i == 4 and {642, 31884, 42292} or {2139, 45438, 42292})[j]
            local _, _, tex = GetSpellInfo(id)
            icon.tex:SetTexture(tex); icon.time:SetText(tostring(j * 7)); icon.progress:SetValue(j / 4); icon:Show()
            local kind = N.kinds[id]
            local c = N.kindColors[kind]
            icon.tag:SetText("~" .. kind); icon:SetBackdropBorderColor(c[1], c[2], c[3], 1)
        end
        if i > 3 then
            f.state:SetText("PVP")
            local class = i == 4 and "PALADIN" or "MAGE"
            local cc = RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
            if cc then f.health:SetStatusBarColor(cc.r, cc.g, cc.b) end
            local c = N.colors[state]
            f.name:SetTextColor(c[1], c[2], c[3])
        else
            for _, icon in ipairs(f.icons) do icon:Hide() end
        end
    end
end
SLASH_NOVAPLATES1 = "/np"
SLASH_NOVAPLATES2 = "/novaplates"
SlashCmdList.NOVAPLATES = function(msg)
    if not db then return end
    local cmd, rest = string.match(msg or "", "^%s*(%S*)%s*(.-)%s*$")
    cmd = string.lower(cmd or "")
    local value = tonumber(rest)
    if cmd == "test" then Preview()
    elseif cmd == "compact" then
        db.width, db.height, db.scale = 150, 12, .9
        for _, p in pairs(plates) do Layout(p.visual) end
        Say("Compact: width 150, height 12, scale 0.9.")
    elseif cmd == "tank" then
        if rest == "auto" then db.tankName = nil; Say("Using raid Main Tank assignments.")
        elseif rest == "" then
            if UnitIsPlayer("target") and (UnitInParty("target") or UnitInRaid("target") or UnitIsUnit("target", "player")) then
                db.tankName = UnitName("target"); Say("Tank: " .. db.tankName)
            else Say("Target your tank in the group, then /np tank. Or /np tank NAME") end
        else db.tankName = rest; Say("Tank: " .. rest) end
        RebuildUnits()
    elseif cmd == "enemy" or cmd == "interrupt" then
        if rest == "on" then db[cmd] = true
        elseif rest == "off" then db[cmd] = false
        else db[cmd] = not db[cmd] end
        Say(cmd .. ": " .. (db[cmd] and "ON" or "OFF"))
    elseif cmd == "status" then
        local active, visible, bound, discovered, icons = 0, 0, 0, 0, 0
        for _, timers in pairs(cooldowns) do
            for _, timer in pairs(timers) do if timer.expiry > GetTime() then active = active + 1 end end
        end
        for _, p in pairs(plates) do
            discovered = discovered + 1
            if p.native:IsShown() then
                visible = visible + 1
                if p.lastGUID then bound = bound + 1 end
                for _, icon in ipairs(p.visual.icons) do if icon:IsShown() then icons = icons + 1 end end
            end
        end
        Say("0.3.1 FIFO enemy=" .. (db.enemy and "ON" or "OFF") .. " active=" .. active .. " plates=" .. visible .. " identified=" .. bound .. " icons=" .. icons)
        Say("Log events=" .. stats.raw .. " casts=" .. stats.observed .. " timers=" .. stats.tracked .. " last=" .. stats.last)
        Say("Discovered=" .. discovered .. " worldChildren=" .. select("#", WorldFrame:GetChildren()) .. " error=" .. (stats.error or "none"))
        Say("Paladin: " .. stats.paladin)
        local targetGUID = UnitGUID("target")
        Say("Target player=" .. tostring(UnitIsPlayer("target")) .. " attack=" .. tostring(UnitCanAttack("player", "target")) ..
            " reaction=" .. tostring(UnitReaction("target", "player")) .. " cachedAttack=" .. tostring(targetGUID and attackablePlayers[targetGUID]))
        if discovered == 0 then
            local printed = 0
            for _, frame in ipairs({WorldFrame:GetChildren()}) do
                local child = frame:GetChildren()
                if child and child:GetObjectType() == "StatusBar" and printed < 2 then
                    local a,b = frame:GetRegions()
                    Say("Candidate textures: " .. tostring(a and a:GetObjectType() == "Texture" and a:GetTexture()) .. " / " .. tostring(b and b:GetObjectType() == "Texture" and b:GetTexture()))
                    printed = printed + 1
                end
            end
        end
    elseif cmd == "kick" and value and GetSpellInfo(value) then
        db.interruptID = value; FindInterrupt(); Say("Your ability: " .. (interruptName or "not learned"))
    elseif cmd == "cd" then
        local id, sec = string.match(rest, "^(%d+)%s+(%d+%.?%d*)$")
        id, sec = tonumber(id), tonumber(sec)
        if id and sec and sec <= 3600 and GetSpellInfo(id) then
            db.custom[id] = sec; Say("Cooldown " .. id .. ": " .. sec .. "s (0 disables).")
        else Say("/np cd SPELL_ID SECONDS (0..3600). Applies to future observed casts.") end
    elseif (cmd == "width" or cmd == "height" or cmd == "scale" or cmd == "threshold") and value then
        local limits = {width = {120,300}, height = {10,30}, scale = {.6,1.8}, threshold = {50,100}}
        db[cmd] = math.max(limits[cmd][1], math.min(limits[cmd][2], value))
        for _, p in pairs(plates) do Layout(p.visual) end
        Say(cmd .. ": " .. db[cmd])
    elseif cmd == "reset" then
        NovaPlatesDB = {}; InitializeDB(); FindInterrupt(); wipe(actors); wipe(petOwners); wipe(attackablePlayers); RebuildUnits(); wipe(cooldowns)
        for _, p in pairs(plates) do Layout(p.visual) end
        Say("Settings reset.")
    else
        Say("/np test | compact | tank [NAME/auto] | width 150 | height 12 | scale 0.9 | threshold 85")
        Say("/np enemy [on/off] | interrupt [on/off] | status | kick SPELL_ID | cd SPELL_ID SECONDS | reset")
    end
end
controller:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        if (...) ~= "NovaPlates" then return end
        InitializeDB()
    elseif event == "PLAYER_LOGIN" then
        if not db then InitializeDB() end
        FindInterrupt(); BuildSpellNames(); RebuildUnits()
        Say("0.3.1 loaded: " .. N.catalogCount .. " cooldown groups, FIFO. PvE threat ON. /np test")
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if db then CombatLog(...) end
    elseif event == "SPELLS_CHANGED" then
        if db then FindInterrupt() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        wipe(cooldowns); wipe(actors); wipe(petOwners); wipe(attackablePlayers)
        if db then RebuildUnits() end
    elseif event == "DUEL_FINISHED" then
        wipe(attackablePlayers)
    elseif event == "UNIT_FACTION" or event == "PLAYER_TARGET_CHANGED" or event == "UPDATE_MOUSEOVER_UNIT" then
        if db then RebuildUnits() end
    end
end)
for _, event in ipairs({"ADDON_LOADED", "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "SPELLS_CHANGED", "COMBAT_LOG_EVENT_UNFILTERED", "DUEL_FINISHED", "UNIT_FACTION", "PLAYER_TARGET_CHANGED", "UPDATE_MOUSEOVER_UNIT"}) do controller:RegisterEvent(event) end
local scan, tick = 0, 0
local function UpdateAll(self, elapsed)
    if not db then return end
    scan, tick = scan + elapsed, tick + elapsed
    local now = GetTime()
    if scan >= .2 then
        for guid, actor in pairs(actors) do if now - actor.seen >= 600 then actors[guid] = nil; attackablePlayers[guid] = nil end end
        for pet, owner in pairs(petOwners) do if not actors[owner] then petOwners[pet] = nil end end
        Discover(); RebuildUnits(); N.Prune(cooldowns, now); scan = 0
    end
    if tick >= .033 then
        for _, p in pairs(plates) do
            if p.native:IsShown() then UpdatePlate(p, now, tick) end
        end
        tick = 0
    end
end
controller:SetScript("OnUpdate", function(self, elapsed)
    local ok, err = pcall(UpdateAll, self, elapsed)
    if not ok then
        stats.error = tostring(err)
        self:SetScript("OnUpdate", nil)
        Say("Update stopped: " .. stats.error .. " - /np status")
    end
end)
