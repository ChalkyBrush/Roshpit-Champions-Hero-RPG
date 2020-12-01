require('heroes/monkey_king/djanghor_constants')
require('heroes/base_ability')

djanghor_feral_sprint = class(base_ability)

modifier_djanghor_feral_sprint = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_djanghor_feral_sprint", "heroes/monkey_king/ability_scripts/djanghor_feral_sprint.lua", LUA_MODIFIER_MOTION_NONE)

function djanghor_feral_sprint:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function djanghor_feral_sprint:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function djanghor_feral_sprint:GetAbilitySlot()
    return DOTA_E_SLOT
end

function djanghor_feral_sprint:GetCastPoint()
    return 0
end

function djanghor_feral_sprint:GetCooldownBase(level)
    return self:GetSpecialValueFor("cooldown")
end

function djanghor_feral_sprint:GetManaCostBase(level)
    return 0
end

function djanghor_feral_sprint:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetRuneValue("e", 4) * DJANGHOR_E4_DURATION_INCREASE
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	caster:RemoveModifierByName("modifier_djanghor_feral_sprint")
	caster:AddNewModifier(caster, self, "modifier_djanghor_feral_sprint", {duration = duration})
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
end

function modifier_djanghor_feral_sprint:IsHidden()
	return false
end

function modifier_djanghor_feral_sprint:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 

    })	
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil
	end	
	local baseSound = "Draghor.Wolf.FeralHaste"

    local particleName = "particles/roshpit/draghor/feral_sprint.vpcf"

    EmitSoundOn(baseSound, caster)
	
    local particleVector = caster:GetAbsOrigin()
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true)
    ParticleManager:SetParticleControl(pfx, 1, particleVector)
    ability.pfx = pfx
    ability.allow_terrain_traverse = true
    ability.interval = 0
    self:StartIntervalThink(0.03)
end

function modifier_djanghor_feral_sprint:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetParent()
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
    ability.interval = ability.interval + 1
end

function modifier_djanghor_feral_sprint:OnRemoved()
	if not IsServer() then
		return false
	end
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil
	end	
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

end

function modifier_djanghor_feral_sprint:CheckState()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = ability.allow_terrain_traverse,
	}
	return state
end

function modifier_djanghor_feral_sprint:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifier_djanghor_feral_sprint:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("movespeed_increase")
end

function modifier_djanghor_feral_sprint:GetModifierMoveSpeed_Max_Increase(params)
	return self:GetAbility():GetSpecialValueFor("movespeed_cap")
end
