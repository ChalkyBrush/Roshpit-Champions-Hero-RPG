require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
supernova_base = class(base_ability)

modifier_solunia_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_r_passive", "heroes/vengeful_spirit/ability_scripts/supernova/supernova_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_r_channeling = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_r_channeling", "heroes/vengeful_spirit/ability_scripts/supernova/supernova_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_falling = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_falling", "heroes/vengeful_spirit/ability_scripts/supernova/supernova_base.lua", LUA_MODIFIER_MOTION_NONE)

function supernova_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solunia_supernova_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solunia_supernova_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	else
		return false
	end
end

function supernova_base:GetManaCostBase(level)
    return 0
end

function supernova_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function supernova_base:GetAbilitySlot()
    return DOTA_R_SLOT
end

function supernova_base:GetCastPoint()
    return 0
end

function supernova_base:GetCooldownBase(level)
    return 1
end

function supernova_base:GetCastRange()
	return 0
end

function supernova_base:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function supernova_base:GetTexture()
    return "arkimus/supernova_base"
end

function supernova_base:GetChannelTimeBase()
    return 3.0
end

function supernova_base:GetCastAnimation()
    return ACT_DOTA_VICTORY
end

function supernova_base:SuperNovaChannelStart()
    local caster = self:GetCaster()
    local ability = self
	StartSoundEvent("Solunia.Supernova", caster)
	ability.rotationIndex = 0
	ability.fallVelocity = 1
	ability.startRotation = vectorToAngle(caster:GetForwardVector())
	caster:AddNewModifier(caster, self, "modifier_solunia_r_channeling", {duration = self:GetChannelTimeBase()})
	caster:RemoveModifierByName("modifier_solunia_between_warp")
end

function supernova_base:SuperNovaChannelFinish(interrupted)
	local caster = self:GetCaster()
	local ability = self
	caster:RemoveModifierByName("modifier_channel_start")
	caster:RemoveModifierByName("modifier_solunia_r_channeling")
	caster:AddNewModifier(caster, ability, "modifier_solunia_falling", {duration = 2})
	StopSoundEvent("Solunia.Supernova", caster)
	if not interrupted then
		local position = caster:GetAbsOrigin()
		self:MainExplosion(position)
		self:SoluniaStateSwap()
		Filters:CastSkillArguments(BASE_ABILITY_R, caster)
	end
end

function supernova_base:MainExplosion(position)
	local caster = self:GetCaster()
	local ability = self
	local particleName = self:GetMainExplosionParticleName()
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, -120))
	ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	-- caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	EmitSoundOn("Solunia.Supernova.Explode", caster)
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("damage")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, self:GetAbilityDamageType(), BASE_ABILITY_R, self:GetAbilityElement(1), self:GetAbilityElement(2))
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end
	GridNav:DestroyTreesAroundPoint(position, 240, false)
end

function supernova_base:SoluniaStateSwap()
	local caster = self:GetCaster()
	local ability_slots = {DOTA_E_SLOT, DOTA_R_SLOT}
	for i = 1, #ability_slots, 1 do
		local ability_slot = ability_slots[i]
		local old_ability = caster:GetAbilityByIndex(ability_slot)
		local modifier_name_to_remove = old_ability:GetIntrinsicModifierName()
		if modifier_name_to_remove then
			caster:RemoveModifierByName(modifier_name_to_remove)
		end

		CustomAbilities:AddAndOrSwapSkill(caster, old_ability:GetAbilityName(), old_ability:GetSwapAbilityName(), ability_slot)

		local new_ability = caster:GetAbilityByIndex(ability_slot)
		local modifier_name_swap = new_ability:GetIntrinsicModifierName()
		if modifier_name_swap then
			caster:AddNewModifier(caster, new_ability, modifier_name_swap, {})
		end
	end
	
	-- if self:IsSoluniaState(SOLUNIA_STATE_SOLAR) then
	-- 	CustomAbilities:AddAndOrSwapSkill(caster, "solunia_warp_flare_solar", "solunia_warp_flare_lunar", DOTA_E_SLOT)
	-- 	CustomAbilities:AddAndOrSwapSkill(caster, "solunia_supernova_solar", "solunia_supernova_lunar", DOTA_R_SLOT)
	-- elseif self:IsSoluniaState(SOLUNIA_STATE_LUNAR) then
	-- 	CustomAbilities:AddAndOrSwapSkill(caster, "solunia_warp_flare_lunar", "solunia_warp_flare_solar", DOTA_E_SLOT)
	-- 	CustomAbilities:AddAndOrSwapSkill(caster, "solunia_supernova_lunar", "solunia_supernova_solar", DOTA_R_SLOT)
	-- end


	-- for i = 1, #ability_slots, 1 do
	-- 	local new_ability = caster:GetAbilityByIndex(ability_slots[i])
	-- 	local modifier_name_swap = new_ability:GetIntrinsicModifierName()
	-- 	if modifier_name_swap then
	-- 		caster:AddNewModifier(caster, new_ability, modifier_name_swap, {})
	-- 	end
	-- end
end


function supernova_base:GetIntrinsicModifierName()
	return "modifier_solunia_r_passive"
end

-- PASSIVE

function modifier_solunia_r_passive:IsHidden()
	return true
end

function modifier_solunia_r_passive:GetStatusEffectName()
	local ability = self:GetAbility()
	if ability:IsSoluniaState(SOLUNIA_STATE_SOLAR) then
		return "particles/status_fx/status_effect_gods_strength.vpcf"
	else
		return false
	end
end

function modifier_solunia_r_passive:StatusEffectPriority()
	return 10
end

-- CHANNELING MODIFIER

function modifier_solunia_r_channeling:IsHidden()
	return true
end

function modifier_solunia_r_channeling:OnCreated()
	if not IsServer() then
		return false
	end
	self:CreateRoshpitModifierParticle()
	self:StartIntervalThink(0.03)
end

function modifier_solunia_r_channeling:SetRoshpitParticleControlPoints(pfx)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), self:GetEffectAttachType(), self:GetRoshpitParticleAttachPoint(), self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), self:GetEffectAttachType(), self:GetRoshpitParticleAttachPoint(), self:GetParent():GetAbsOrigin(), true)
end

function modifier_solunia_r_channeling:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

	-- if caster:HasModifier("modifier_solunia_in_between_flare") then
	-- 	return false
	-- end
	local rotation = ability.rotationIndex * 6 + ability.startRotation
	caster:SetAngles(0, rotation, 0)
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 2) + Vector(0, 0, math.sin(math.pi * ability.rotationIndex / 30) * 6))
	if (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) > 199 then
		-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_ulti_above_ground", {})
	else
		-- caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	end
	ability.rotationIndex = ability.rotationIndex + 1
end

function modifier_solunia_r_channeling:GetRoshpitParticleName()
	if self:GetAbility():IsSoluniaState(SOLUNIA_STATE_SOLAR) then
		return "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf"
	elseif self:GetAbility():IsSoluniaState(SOLUNIA_STATE_LUNAR) then
		return "particles/roshpit/solunia/channel_eclipse.vpcf"
	end
end

function modifier_solunia_r_channeling:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_solunia_r_channeling:GetRoshpitParticleAttachPoint()
	return "attach_hitloc"
end

function modifier_solunia_r_channeling:OnDestroy()
	if not IsServer() then
		return false
	end
	self:DestroyRoshpitModifierParticle()
end

-- FALLING MODIFIER

function modifier_solunia_falling:IsHidden()
	return true
end

function modifier_solunia_falling:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_solunia_falling:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state	
end

function modifier_solunia_falling:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if caster:HasModifier("modifier_solunia_r_channeling") then
    	return false
    end
	caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, ability.fallVelocity))
	local acceleration = 2
	acceleration = Filters:GetAdjustedESpeed(caster, acceleration, false)
	ability.fallVelocity = ability.fallVelocity + acceleration
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < ability.fallVelocity / 2 then
		caster:RemoveModifierByName("modifier_solunia_falling")
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.8})
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_start_dust.vpcf", caster:GetAbsOrigin(), 3)
	end
end