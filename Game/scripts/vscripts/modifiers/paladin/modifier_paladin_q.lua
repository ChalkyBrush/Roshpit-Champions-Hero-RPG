modifier_paladin_q = class({})
local class = modifier_paladin_q

local lua_modifiers = {
"modifier_paladin_q_passive",
"modifier_q_slow"
}
for _,modifier in pairs(lua_modifiers) do
	LinkLuaModifier(modifier, "modifiers/paladin/"..modifier, LUA_MODIFIER_MOTION_NONE)
end

function class:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
	return funcs
end

function class:GetIntrinsicModifierName()
	return "modifier_paladin_q_passive"
end

function class:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("attack_damage_bonus")
end

function class:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function class:IsDebuff()
	return false
end

function class:OnAttackLanded( event )
	local target = event.target
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if event.attacker ~= caster then return end
	local damage = ability:GetSpecialValueFor("damage") + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.15*caster.q1_level
	local heal = caster:GetMaxHealth()*ability:GetSpecialValueFor("heal_percent")/100
	EmitSoundOn("Paladin.HeroicAttackLand", target)
	if not ability.zapParticleCount then
    	ability.zapParticleCount = 0
    end
    if ability.zapParticleCount < 15 then
    	ability.zapParticleCount = ability.zapParticleCount + 1
		local dagon_particle = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf",  PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(dagon_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
		local particle_effect_intensity = 300 + (60 * ability:GetLevel())  --Control Point 2 in Dagon's particle effect takes a number between 400 and 800, depending on its level.
		ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(dagon_particle, false)
			ParticleManager:ReleaseParticleIndex(dagon_particle)
			ability.zapParticleCount = ability.zapParticleCount - 1
		end)
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )

	Filters:ApplyHeal(caster, caster, heal, true)

	
	if #enemies > 0 then
		if not ability.goldParticleCount then
			ability.goldParticleCount = 0
		end
		for _,enemy in pairs(enemies) do
			if ability.goldParticleCount < 20 then
				ability.goldParticleCount = ability.goldParticleCount + 1
				CustomAbilities:QuickAttachParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold_lvl2_a.vpcf", enemy, 1)
				Timers:CreateTimer(1.2, function()
					ability.goldParticleCount = ability.goldParticleCount - 1
				end)
			end
			if not target.holy_struck then
				target.holy_struck = true
				Timers:CreateTimer( 8, function() target.holy_struck = false end)
				enemy:AddNewModifier(caster, ability, "modifier_q_slow", {duration = 4})
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
		end
	end 
end

function class:OnCreated()
	local caster = self:GetCaster()
	if not caster.paladin_q_particle then
		caster.paladin_q_particle = ParticleManager:CreateParticle("particles/roshpit/paladin/heroic_fury_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
end

function class:OnDestroy()
	local caster = self:GetCaster()
	if caster.paladin_q_particle then
		ParticleManager:DestroyParticle(caster.paladin_q_particle, false)
		ParticleManager:ReleaseParticleIndex(caster.paladin_q_particle)
		caster.paladin_q_particle = nil
	end
end

function class:IsHidden()
	return false
end