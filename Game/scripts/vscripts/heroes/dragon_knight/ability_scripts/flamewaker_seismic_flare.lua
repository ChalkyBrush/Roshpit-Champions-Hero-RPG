require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_seismic_flare = class(base_ability)

modifier_flamewaker_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_q_passive", "heroes/dragon_knight/ability_scripts/flamewaker_seismic_flare.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_seismic_flare_vacuum = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_seismic_flare_vacuum", "heroes/dragon_knight/ability_scripts/flamewaker_seismic_flare.lua", LUA_MODIFIER_MOTION_NONE)

function flamewaker_seismic_flare:GetManaCostBase(level)
    return 0
end

function flamewaker_seismic_flare:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function flamewaker_seismic_flare:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function flamewaker_seismic_flare:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function flamewaker_seismic_flare:GetCastPoint()
    return 0.2
end

function flamewaker_seismic_flare:GetCastRange()
    return FLAMEWAKER_Q_CAST_RANGE
end

function flamewaker_seismic_flare:GetCooldownBase(level)
    return FLAMEWAKER_Q_COOLDOWN
end

function flamewaker_seismic_flare:GetIntrinsicModifierName()
	return "modifier_flamewaker_q_passive"
end

function flamewaker_seismic_flare:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	local target_position = self:GetCursorPosition()
	ability.center_point = target_position
	EmitSoundOnLocationWithCaster(target_position, "Flamewaker.SeismicFlare.Pre", self:GetCaster())
	if ability.pre_cast_pfx then
		ParticleManager:DestroyParticle(ability.pre_cast_pfx, false)
		ability.pre_cast_pfx = nil
	end
	local pfx = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target_position)
	ability.pre_cast_pfx = pfx

	local radius = self:GetAOERadius()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    ability.vacuum_enemy_indeces = {}
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
        	if not enemy.pushLock then
	            enemy:AddNewModifier(self:GetCaster(), ability, "modifier_flamewaker_seismic_flare_vacuum", {duration = 0.4})
	            table.insert(ability.vacuum_enemy_indeces, enemy:GetEntityIndex())
	        end
        end
    end

	return true
end

function flamewaker_seismic_flare:OnAbilityPhaseInterrupted()
	local ability = self
	if ability.pre_cast_pfx then
		ParticleManager:DestroyParticle(ability.pre_cast_pfx, false)
		ability.pre_cast_pfx = nil
	end
	if ability.vacuum_enemy_indeces then
		for _, enemyIndex in pairs(ability.vacuum_enemy_indeces) do
			local enemy = EntIndexToHScript(enemyIndex)
			if enemy:EntityExistsAndIsAlive() then
				enemy:RemoveModifierByName("modifier_flamewaker_seismic_flare_vacuum")
			end
		end
	end
end

function flamewaker_seismic_flare:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function flamewaker_seismic_flare:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCursorPosition()
    CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/roshan_slam_debris_small.vpcf", target_position, 4)
    EmitSoundOnLocationWithCaster(target_position, "Flamewaker.SeismicFlare.Cast", self:GetCaster())
    local pfx_to_destroy = ability.pre_cast_pfx
    ability.pre_cast_pfx = nil
    Timers:CreateTimer(4, function()
    	if pfx_to_destroy then
    		ParticleManager:DestroyParticle(pfx_to_destroy, false)
    	end
    end)
    local stun_duration = ability:GetSpecialValueFor("stun_duration")
    local radius = self:GetAOERadius()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local damage = ability:GetSpecialValueFor("damage")
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
        	Filters:ApplyStun(caster, stun_duration, enemy)
        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
        end
    end
    ability.damage = damage
    Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

-- PASSIVE

function modifier_flamewaker_q_passive:IsHidden()
    return true
end

function modifier_flamewaker_q_passive:RemoveOnDeath()
    return false
end

function modifier_flamewaker_q_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_HEALTH_REGEN,
       	MODIFIER_ROSHPIT_BASE_ARMOR_BONUS
    })

end

function modifier_flamewaker_q_passive:GetRoshpitMasterHealthRegen()
	return self:GetCaster():GetRuneValue("q", 1)*FLAMEWAKER_Q1_HEALTH_REGEN
end

function modifier_flamewaker_q_passive:GetRoshpitBaseArmorBonus()
	return self:GetCaster():GetRuneValue("q", 1)*FLAMEWAKER_Q1_ARMOR
end

-- VACUUM MODIFIER

function modifier_flamewaker_seismic_flare_vacuum:IsHidden()
	return true
end

function modifier_flamewaker_seismic_flare_vacuum:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_flamewaker_seismic_flare_vacuum:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return funcs
end

function modifier_flamewaker_seismic_flare_vacuum:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local target = self:GetParent()
		local position = ability.center_point
		local pullFV = ((position - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local newPosition = GetGroundPosition(target:GetAbsOrigin() + pullFV*4, target) 
		local obstruction = WallPhysics:FindNearestObstruction(newPosition)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, target)
		if not blockUnit then
			target:SetAbsOrigin(newPosition)
		end
	end
end

function modifier_flamewaker_seismic_flare_vacuum:OnRemoved()
	if IsServer() then
		local target = self:GetParent()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end
end

function modifier_flamewaker_seismic_flare_vacuum:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end