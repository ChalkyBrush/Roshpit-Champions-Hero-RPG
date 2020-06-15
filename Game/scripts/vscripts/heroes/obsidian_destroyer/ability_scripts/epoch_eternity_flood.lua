require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_eternity_flood = class(base_ability)

modifier_epoch_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_r_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_eternity_flood.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_r_channeling = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_r_channeling", "heroes/obsidian_destroyer/ability_scripts/epoch_eternity_flood.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_r_dummy_aura = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_r_dummy_aura", "heroes/obsidian_destroyer/ability_scripts/epoch_eternity_flood.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_r_vacuum = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_r_vacuum", "heroes/obsidian_destroyer/ability_scripts/epoch_eternity_flood.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_r_freeze = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_r_freeze", "heroes/obsidian_destroyer/ability_scripts/epoch_eternity_flood.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_eternity_flood:GetManaCostBase(level)
    return 0
end

function epoch_eternity_flood:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function epoch_eternity_flood:GetAbilitySlot()
    return DOTA_R_SLOT
end

function epoch_eternity_flood:GetCastPoint()
    return 0
end

function epoch_eternity_flood:GetCooldownBase(level)
    return self:GetSpecialValueFor("cooldown")
end

function epoch_eternity_flood:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function epoch_eternity_flood:GetChannelTimeBase()
    return 2.0
end

function epoch_eternity_flood:GetCastAnimation()
    return ACT_DOTA_VICTORY
end

function epoch_eternity_flood:GetIntrinsicModifierName()
	return "modifier_epoch_r_passive"
end

function epoch_eternity_flood:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function epoch_eternity_flood:OnSpellStartBase()
    local caster = self:GetCaster()
    local ability = self
    local position = self:GetCastPosition()
    if ability.channel_pfx then
    	ParticleManager:DestroyParticle(ability.channel_pfx, false)
    	ability.channel_pfx = nil
    end
    if ability.black_hole_dummy then
    	UTIL_Remove(ability.black_hole_dummy)
    	ability.black_hole_dummy = nil
    end
    if self:GetChannelTime() > 0 then
	    ability.channel_pfx = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/time_ulti.vpcf", PATTACH_CUSTOMORIGIN, caster)
	    ParticleManager:SetParticleControl(ability.channel_pfx, 0, position+Vector(0,0,120))
	    StartSoundEvent("Epoch.EternityFlood.BlackHole.LP", caster)
	    caster:AddNewModifier(caster, ability, "modifier_epoch_r_channeling", {})

	    ability.black_hole_dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
		ability.black_hole_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

		ability.black_hole_dummy:SetDayTimeVisionRange(500)
		ability.black_hole_dummy:SetNightTimeVisionRange(500)

		ability.black_hole_dummy:AddNewModifier(ability.black_hole_dummy, ability, "modifier_epoch_r_dummy_aura", {})
	end
    GridNav:DestroyTreesAroundPoint(position, self:GetAOERadius(), false)
end

function epoch_eternity_flood:OnChannelFinish(interrupted)
    if IsServer() then
    	local caster = self:GetCaster()
    	local ability = self
    	local position = self:GetCastPosition()
    	caster:RemoveModifierByName("modifier_channel_start")
    	StopSoundEvent("Epoch.EternityFlood.BlackHole.LP", caster)
    	caster:RemoveModifierByName("modifier_epoch_r_channeling")
    	EmitSoundOnLocationWithCaster(position, "Epoch.EternityFlood.BlackHole.Stop", caster)
	    if ability.channel_pfx then
	    	ParticleManager:DestroyParticle(ability.channel_pfx, false)
	    	ability.channel_pfx = nil
	    end
		if ability.black_hole_dummy then
			UTIL_Remove(ability.black_hole_dummy)
			ability.black_hole_dummy = nil
		end
    	if interrupted then

    	else
    		if not ability.freeze_table then
    			ability.freeze_table = {}
    		end
    		EmitSoundOn("Epoch.EternityFlood.Explode", caster)
    		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.2})

			local pfx = ParticleManager:CreateParticle("particles/roshpit/epoch/eternity_flood_explosion.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, position+Vector(0,0,60))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
			local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage_sum_attrs")*caster:GetSumOfAllAttributes()
			local freeze_duration = self:GetSpecialValueFor("freeze_duration")
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, ability:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_TIME, RPC_ELEMENT_COSMIC)
					local lift_direction = ((enemy:GetAbsOrigin() - position)*Vector(1,1,0)):Normalized()
					ability.freeze_table[enemy:GetEntityIndex()] = {lift_speed = 22, lift_direction = lift_direction, is_frozen = false, is_falling = false}
					enemy:AddNewModifier(caster, ability, "modifier_epoch_r_freeze", {duration = freeze_duration})
				end
			end
			Filters:CastSkillArguments(BASE_ABILITY_R, caster)
		end
    end
end

-- PASSIVE

function modifier_epoch_r_passive:IsHidden()
	return true
end

function modifier_epoch_r_passive:RemoveOnDeath()
	return false
end

function modifier_epoch_r_passive:IsPassive()
	return true
end

function modifier_epoch_r_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        RPC_ELEMENT_TIME
    })
end


function modifier_epoch_r_passive:DeclareFunctions()
	local funcs = {
		
	}
	return funcs
end

-- EPOCH R CHANNEL

function modifier_epoch_r_channeling:OnCreated()
end

function modifier_epoch_r_channeling:IsHidden()
	return true
end

function modifier_epoch_r_channeling:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise_stars.vpcf"
end

function modifier_epoch_r_channeling:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- DUMMY AURA

function modifier_epoch_r_dummy_aura:IsHidden()
	return true
end

function modifier_epoch_r_dummy_aura:OnCreated()
    if not IsServer() then return end
end

function modifier_epoch_r_dummy_aura:IsBuff()
    return true
end

function modifier_epoch_r_dummy_aura:IsAura()
    return true
end

function modifier_epoch_r_dummy_aura:IsAuraActiveOnDeath()
    return false
end

function modifier_epoch_r_dummy_aura:GetAuraRadius()
    return self:GetAbility():GetAOERadius()
end

function modifier_epoch_r_dummy_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_epoch_r_dummy_aura:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function modifier_epoch_r_dummy_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_epoch_r_dummy_aura:RemoveOnDeath()
    return false
end

function modifier_epoch_r_dummy_aura:GetModifierAura()
    return "modifier_epoch_r_vacuum"
end

-- VACUUM MODIFIER

function modifier_epoch_r_vacuum:IsHidden()
	return false
end

function modifier_epoch_r_vacuum:IsDebuff()
	return true
end

function modifier_epoch_r_vacuum:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_epoch_r_vacuum:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_epoch_r_vacuum:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local target = self:GetParent()
	if target.pushLock then
		return false
	end
	local caster = self:GetCaster()
	if caster and caster:EntityExistsAndIsAlive() then
		local pull_direction = ((caster:GetAbsOrigin() - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()

		local pullForce = 2
		local centrifugalForce = 3

		local perpFV = WallPhysics:rotateVector(pull_direction, -2*math.pi/4)

		local newPos = target:GetAbsOrigin() + pull_direction*pullForce + perpFV*centrifugalForce
		target:SetAbsOrigin(newPos)
	end
end

-- freeze modifier

function modifier_epoch_r_freeze:IsHidden()
	return false
end

function modifier_epoch_r_freeze:IsDebuff()
	return true
end

function modifier_epoch_r_freeze:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_epoch_r_freeze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}

	return funcs
end

function modifier_epoch_r_freeze:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_epoch_r_freeze:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local target = self:GetParent()
	if target.pushLock or target.jumpLock then
		return false
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability.freeze_table[target:GetEntityIndex()].is_frozen then
		return false
	end
	if ability.freeze_table[target:GetEntityIndex()].is_falling then
		local pushBackForce = 0
		local newPos = target:GetAbsOrigin() + ability.freeze_table[target:GetEntityIndex()].lift_direction*pushBackForce + ability.freeze_table[target:GetEntityIndex()].lift_speed*Vector(0,0,1)
		ability.freeze_table[target:GetEntityIndex()].lift_speed = ability.freeze_table[target:GetEntityIndex()].lift_speed - 1
		target:SetAbsOrigin(newPos)
		if target:GetDistanceFromGround() < ability.freeze_table[target:GetEntityIndex()].lift_speed*-1 then
			target:RemoveModifierByName("modifier_epoch_r_freeze")
		end
	else
		ability.freeze_table[target:GetEntityIndex()].lift_speed = ability.freeze_table[target:GetEntityIndex()].lift_speed - 1
		if ability.freeze_table[target:GetEntityIndex()].lift_speed < 0 then
			ability.freeze_table[target:GetEntityIndex()].is_frozen = true
			return false
		end
		local pushBackForce = 6
		local newPos = target:GetAbsOrigin() + ability.freeze_table[target:GetEntityIndex()].lift_direction*pushBackForce + ability.freeze_table[target:GetEntityIndex()].lift_speed*Vector(0,0,1)
		target:SetAbsOrigin(newPos)
	end
end

function modifier_epoch_r_freeze:CheckState()
	if not IsServer() then
		return false
	end
	local target = self:GetParent()
	local ability = self:GetAbility()
	local state = {
		[MODIFIER_STATE_FROZEN] = ability.freeze_table[target:GetEntityIndex()].is_frozen,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end


function modifier_epoch_r_freeze:OnRemoved()
	if not IsServer() then
		return false
	end
	local target = self:GetParent()
	local ability = self:GetAbility()
	if not ability.freeze_table[target:GetEntityIndex()].is_falling then
		ability.freeze_table[target:GetEntityIndex()].is_falling = true
		ability.freeze_table[target:GetEntityIndex()].is_frozen = false
		target:AddNewModifier(self:GetCaster(), ability, "modifier_epoch_r_freeze", {duration = 2})
	else
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end
end

function modifier_epoch_r_freeze:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

function modifier_epoch_r_freeze:StatusEffectPriority()
	return 15
end