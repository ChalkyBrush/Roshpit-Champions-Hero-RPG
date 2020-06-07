require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_heat_wave = class(base_ability)

modifier_flamewaker_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_e_passive", "heroes/dragon_knight/ability_scripts/flamewaker_heat_wave.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_e_heat_wave_base = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_e_heat_wave_base", "heroes/dragon_knight/ability_scripts/flamewaker_heat_wave.lua", LUA_MODIFIER_MOTION_NONE)

function flamewaker_heat_wave:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function flamewaker_heat_wave:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function flamewaker_heat_wave:GetAbilitySlot()
    return DOTA_E_SLOT
end

function flamewaker_heat_wave:GetCastPoint()
    return 0
end

function flamewaker_heat_wave:GetCooldownBase(level)
    return self:GetSpecialValueFor("cooldown")
end

function flamewaker_heat_wave:GetManaCostBase(level)
    return 0
end

function flamewaker_heat_wave:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_flamewaker_e_heat_wave_base", {duration = duration})
end

function flamewaker_heat_wave:GetIntrinsicModifierName()
	return "modifier_flamewaker_e_passive"
end

-- PASSIVE

function modifier_flamewaker_e_passive:IsHidden()
	return true
end

function modifier_flamewaker_e_passive:RemoveOnDeath()
	return false
end

function modifier_flamewaker_e_passive:IsPassive()
	return true
end

function modifier_flamewaker_e_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
    })
end

function modifier_flamewaker_e_passive:GetRoshpitArmorPierceBonus()
	local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - FLAMEWAKER_E1_BASE_MS_REQ)
	return ms_over_threshold * FLAMEWAKER_E1_PIERCE_PER_MS_OVER_THRESH
end

function modifier_flamewaker_e_passive:GetRoshpitMasterBaseDMG()
	local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - FLAMEWAKER_E1_BASE_MS_REQ)
	return ms_over_threshold * FLAMEWAKER_E1_BASE_DMG_PER_MS_OVER_THRESH
end
-- MAIN MODIFIER

function modifier_flamewaker_e_heat_wave_base:IsHidden()
	return false
end

function modifier_flamewaker_e_heat_wave_base:OnCreated()
	if not IsServer() then
		return false
	end
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil
	end	
    EmitSoundOn("Flamewaker.HeatWaveCast", caster)
    StartSoundEvent("Flamewaker.HeatWave.LP", caster)

    local particleName = "particles/roshpit/flamewaker/heat_wave.vpcf"
    local particleVector = caster:GetAbsOrigin() - (caster:GetForwardVector() * 90)
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true)
    ParticleManager:SetParticleControl(pfx, 1, particleVector + Vector(0, 0, 100))
    ability.pfx = pfx
    ability.allow_terrain_traverse = true
    self:StartIntervalThink(0.03)
end

function modifier_flamewaker_e_heat_wave_base:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if ability.pfx then
		local pfxPos = caster:GetAbsOrigin() + Vector(0, 0, 80) - (caster:GetForwardVector() * 90)
		ParticleManager:SetParticleControl(ability.pfx, 1, pfxPos)
	end
    if ability.allow_terrain_traverse then
        local newPos = caster:GetAbsOrigin() + caster:GetForwardVector() * 62
        local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin() * Vector(1, 1, 0))
        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos * Vector(1, 1, 0), caster)
        if blockUnit then
            caster:SetAbsOrigin(caster:GetAbsOrigin() - caster:GetForwardVector() * 60)
            WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
            ability.allow_terrain_traverse = false
        end
    end
end

function modifier_flamewaker_e_heat_wave_base:OnRemoved()
	if not IsServer() then
		return false
	end
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil
	end	
	StopSoundEvent("Flamewaker.HeatWave.LP", caster)
	EmitSoundOn("Flamewaker.HeatWave.End", caster)
end

function modifier_flamewaker_e_heat_wave_base:CheckState()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = ability.allow_terrain_traverse,
	}
	return state
end

function modifier_flamewaker_e_heat_wave_base:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}

	return funcs
end

function modifier_flamewaker_e_heat_wave_base:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_flamewaker_e_heat_wave_base:GetModifierMoveSpeed_Max_Increase(params)
	return FLAMEWAKER_E_MS_CAP_BONUS
end