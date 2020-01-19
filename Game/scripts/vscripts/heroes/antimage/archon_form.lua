LinkLuaModifier("arkimus_archon_form_lua", "modifiers/arkimus/arkimus_archon_form_lua", LUA_MODIFIER_MOTION_NONE)
require('heroes/antimage/machinal_jump')

function archon_init_seafortress(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()

	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_archon_form", {})
	caster:AddNewModifier(caster, ability, "arkimus_archon_form_lua", {})
	caster:SetRangedProjectileName("particles/base_attacks/arkimus_archon_form.vpcf")
	Events:ColorWearablesAndBase(caster, Vector(0, 0, 0))
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	ability.r_4_level = 20
	EmitSoundOn("Arkimus.ArchonForm.Start", caster)
end

