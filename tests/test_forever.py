from pathlib import Path
import sys
sys.path.insert(0,str(Path('.test-deps').resolve()))
from lupa.lua51 import LuaRuntime
l=LuaRuntime(unpack_returned_tuples=True)
l.execute('''SlashCmdList={}; hidden={}; hooks={}; vars={nameplateShowEnemies='0',nameplateStyle='6',nameplateSize='2',nameplateStackingTypes='0',nameplateThreatDisplay='0'}
function print() end
function CreateFrame() local f={}; function f:RegisterEvent() end; function f:SetScript(k,v) self[k]=v end; driver=f; return f end
function issecretvalue(v) return v==hidden end
function InCombatLockdown() return combat end
C_CVar={GetCVar=function(k) return vars[k] end,SetCVar=function(k,v) assert(not combat); vars[k]=v end}
bar={SetStatusBarColor=function(self,r,g,b) self.r=r;self.g=g;self.b=b end}
uf={healthBar=bar,IsForbidden=function() return false end,IsShown=function() return true end}
plate={UnitFrame=uf,IsForbidden=function() return false end}
C_NamePlate={GetNamePlateForUnit=function() return plate end,GetNamePlates=function() return {} end}
function CompactUnitFrame_UpdateHealthColor(f) f.healthBar:SetStatusBarColor(.5,.5,.5); for _,h in ipairs(hooks) do h(f) end end
function hooksecurefunc(name,fn) table.insert(hooks,fn) end
function UnitIsPlayer(u) return player or u=='target' end
function UnitIsDeadOrGhost() return dead end
function UnitIsTapDenied() return false end
function UnitReaction() return reaction end
function UnitThreatSituation() return threat end
function UnitAffectingCombat() return fighting end
function UnitIsUnit() return selftarget end
function UnitGUID() return 'tank-guid' end
function UnitIsFriend() return true end
function UnitGroupRolesAssigned() return role end
function UnitInParty() return true end
function UnitInRaid() return nil end
reaction=3
''')
l.execute(Path('NovaPlatesForever/Core.lua').read_text())
l.execute('''driver:OnEvent('PLAYER_LOGIN'); driver:OnEvent('NAME_PLATE_UNIT_ADDED','nameplate1')
assert(vars.nameplateSize=='1' and vars.nameplateShowEnemies=='1')
assert(bar.r==.86)
reaction=4; driver:OnUpdate(.2); assert(bar.r==1 and bar.g==.83)
threat=3; driver:OnUpdate(.2); assert(bar.g==.16)
threat=1; driver:OnUpdate(.2); assert(bar.g==.80)
threat=0; fighting=true; role='TANK'; driver:OnUpdate(.2); assert(bar.g==.88)
threat=hidden; driver:OnUpdate(.2); assert(bar.r==.5)
threat=0; player=true; driver:OnUpdate(.2); assert(bar.r==.5)
player=false; dead=true; driver:OnUpdate(.2); assert(bar.r==.5)
dead=false; fighting=false; reaction=hidden; driver:OnUpdate(.2); assert(bar.r==.5)
reaction=3; SlashCmdList.NOVAPLATESFOREVER('restore'); driver:OnUpdate(.2); assert(bar.r==.5 and vars.nameplateSize=='2')
combat=true; SlashCmdList.NOVAPLATESFOREVER('compact'); assert(vars.nameplateSize=='2')
combat=false; driver:OnEvent('PLAYER_REGEN_ENABLED'); assert(vars.nameplateSize=='1')
driver:OnEvent('NAME_PLATE_UNIT_REMOVED','nameplate1'); bar.r=9; driver:OnUpdate(.2); assert(bar.r==9)
''')
print('PASS: NPC reactions, aggro/warning/tank, secret data fallback, players/dead units, restore, combat deferral, plate removal; Lua 5.1')
