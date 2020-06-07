require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_seismic_flare = class(base_ability)

modifier_flamewaker_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_q_passive", "heroes/dragon_knight/ability_scripts/flamewaker_seismic_flare.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_seismic_flare_vacuum = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_seismic_flare_vacuum", "heroes/dragon_knight/ability_scripts/flamewaker_seismic_flare.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_rune_q_3_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_rune_q_3_buff", "heroes/dragon_knight/ability_scripts/flamewaker_seismic_flare.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_rune_q_4 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_rune_q_4", "heroes/dragon_knight/ability_scripts/flamewaker_seismic_flare.lua", LUA_MODIFIER_MOTION_NONE)

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
            enemy:AddNewModifier(self:GetCaster(), ability, "modifier_flamewaker_seismic_flare_vacuum", {duration = 0.4})
            table.insert(ability.vacuum_enemy_indeces, enemy:GetEntityIndex())
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
    local q_4_level = caster:GetRuneValue("q", 4)
    local stun_duration = ability:GetSpecialValueFor("stun_duration")
    local radius = self:GetAOERadius()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local damage = ability:GetSpecialValueFor("damage")
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
        	Filters:ApplyStun(caster, stun_duration, enemy)
        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
        	self:q_4_event(q_4_level)
        end
    end
    ability.damage = damage
    Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function flamewaker_seismic_flare:q_4_event(q_4_level)
	if q_4_level > 0 then
		local luck = RandomInt(1, 1000)
		if luck <= q_4_level*FLAMEWAKER_Q4_PROC_CHANCE*10 then
			local caster = self:GetCaster()
			local r_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
			r_ability:EndCooldown()
			local duration = FLAMEWAKER_Q4_FREECAST_DURATION_BASE + q_4_level*FLAMEWAKER_Q4_FREECAST_DURATION
			caster:AddNewModifier(caster, self, "modifier_flamewaker_rune_q_4", {duration = duration})
		end
	end
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
       	MODIFIER_ROSHPIT_BASE_ARMOR_BONUS,
       	MODIFIER_SPECIAL_TYPE_ON_STUN,
       	MODIFIER_ROSHPIT_PERCENT_HEALTH_BONUS
    })

end

function modifier_flamewaker_q_passive:GetRoshpitMasterHealthRegen()
	return self:GetCaster():GetRuneValue("q", 1)*FLAMEWAKER_Q1_HEALTH_REGEN
end

function modifier_flamewaker_q_passive:GetRoshpitBaseArmorBonus()
	return self:GetCaster():GetRuneValue("q", 1)*FLAMEWAKER_Q1_ARMOR
end

function modifier_flamewaker_q_passive:GetPercentHealthBonus()
	return self:GetCaster():GetRuneValue("q", 2)*(FLAMEWAKER_Q2_HEALTH_PCT/100)
end

function modifier_flamewaker_q_passive:OnStun(event)
	local caster = self:GetCaster()
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_flamewaker_rune_q_3_buff", {duration = FLAMEWAKER_Q3_DURATION})
	end
end

-- VACUUM MODIFIER

function modifier_flamewaker_seismic_flare_vacuum:IsHidden()
	return true
end

function modifier_flamewaker_seismic_flare_vacuum:RemoveOnDeath()
	return false
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
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local target = self:GetParent()
		if not target.pushLock then
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

-- Q3 MODIFIER

function modifier_flamewaker_rune_q_3_buff:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
    })
end

function modifier_flamewaker_rune_q_3_buff:IsHidden()
	return false
end

function modifier_flamewaker_rune_q_3_buff:IsBuff()
	return true
end

function modifier_flamewaker_rune_q_3_buff:RemoveOnDeath()
	return true
end

function modifier_flamewaker_rune_q_3_buff:GetRoshpitMasterBaseDMG()
	return self:GetCaster():GetRuneValue("q", 3)*FLAMEWAKER_Q3_BASE_DMG
end

function modifier_flamewaker_rune_q_3_buff:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_e.vpcf"
end

function modifier_flamewaker_rune_q_3_buff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_flamewaker_rune_q_3_buff:GetTexture()
	return "flamewaker/flamewaker_rune_q_3"
end
-- Q_4_MODIFIER

function modifier_flamewaker_rune_q_4:IsHidden()
	return false
end

function modifier_flamewaker_rune_q_4:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({
    	MODIFIER_ROSHPIT_R_PCT_CHANNELTIME_MOD
    })
    local hero = self:GetParent()
    EmitSoundOn("Flamewaker.Q4.Activate", hero)
end

function modifier_flamewaker_rune_q_4:GetEffectName()
	return "particles/roshpit/flamewaker/flamewaker_q4_buff.vpcf"
end

function modifier_flamewaker_rune_q_4:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_flamewaker_rune_q_4:GetRoshpitRPctChanneltimeModifier()
    return - ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_PCT_CHANNELTIME_MOD
end

function modifier_flamewaker_rune_q_4:GetTexture()
	return "flamewaker/flamewaker_rune_q_4"
end