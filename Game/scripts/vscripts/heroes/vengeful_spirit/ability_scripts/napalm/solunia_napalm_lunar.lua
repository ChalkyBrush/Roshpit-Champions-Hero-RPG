require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/napalm/napalm_base')
solunia_napalm_lunar = class(napalm_base)

modifier_napalm_counter_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_counter_lunar", "heroes/vengeful_spirit/ability_scripts/napalm/solunia_napalm_lunar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_napalm_lunar:OnSpellStartBase()
    self:NapalmStart()
end

function solunia_napalm_lunar:GetSwapAbilityName()
	return "solunia_napalm_solar"
end
