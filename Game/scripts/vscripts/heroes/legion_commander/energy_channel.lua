local constants = require('/heroes/legion_commander/constants')
function energy_shield_create(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_energy_channel_no_cast_filter") then
		Filters:CastSkillArguments(2, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_channel_no_cast_filter", {duration = 0.5})
	end

	CustomAbilities:QuickAttachParticle("particles/roshpit/mystic_assassin/mountain_a_b_glow.vpcf", caster, 1)
	local w1_level = caster:GetRuneValue("w", 1)
	if w1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_protector_w1_regen", {})
		caster:SetModifierStackCount("modifier_protector_w1_regen", caster, w1_level)
	end

	local w_2_level = caster:GetRuneValue("w", 2)
	ability.w_3_level = caster:GetRuneValue("w", 3)
	if ability.w_3_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_protector_rune_w_3_aura", {})
	end
	ability.w_4_level = caster:GetRuneValue("w", 4)
	if ability.w_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_protector_rune_w_4_aura", {})
	end
	caster.mountainGuardianMagic = 1 + (w_2_level * 0.04)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_channel_animating", {duration = 6})
	StartAnimation(caster, {duration = 7, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
	EmitSoundOn("MysticAssasin.ShieldYell"..RandomInt(1, 2), caster)
	Timers:CreateTimer(0.1, function()
		StartSoundEvent("MysticAssasin.EnergyChannelLoop", caster)
	end)
end

function energy_shield_think(event)
	local caster = event.caster
	local ability = event.ability
	local mana_drain = event.mana_drain

	if caster:GetMana() < mana_drain then
		ability:ToggleAbility()
	end
	caster:ReduceMana(mana_drain)

	Filters:CastSkillArguments(2, caster)
	CustomAbilities:IceQuill(event)
	if not caster:HasModifier("modifier_energy_channel_animating") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_channel_animating", {duration = 6})
		StartAnimation(caster, {duration = 7, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
	end
	if caster:IsSilenced() then
		ability:ToggleAbility()
	end
end

function energy_shield_end(event)
	local caster = event.caster
	EndAnimation(caster)
	caster:RemoveModifierByName("modifier_protector_w1_regen")
	caster:RemoveModifierByName("modifier_protector_rune_w_3_aura")
	caster:RemoveModifierByName("modifier_protector_rune_w_4_aura")
	Timers:CreateTimer(0.1, function()
		StopSoundEvent("MysticAssasin.EnergyChannelLoop", caster)
	end)
end

function protector_c_b_zap(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local c_b_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.25 * ability.w_3_level
	Filters:TakeArgumentsAndApplyDamage(target, caster, c_b_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_EARTH)
	local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 80), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin() + Vector(0, 0, 80), true)
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function protector_d_b_aura_init(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_protector_d_b_armor_aura_effect", {})
	target:SetModifierStackCount("modifier_protector_d_b_armor_aura_effect", caster, ability.w_4_level)
end
