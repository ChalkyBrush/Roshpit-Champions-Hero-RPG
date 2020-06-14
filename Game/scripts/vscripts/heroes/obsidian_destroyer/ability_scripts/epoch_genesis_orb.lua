require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_genesis_orb = class(base_ability)

modifier_epoch_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_w_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_genesis_orb.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_w_3_int = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_w_3_int", "heroes/obsidian_destroyer/ability_scripts/epoch_genesis_orb.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_genesis_orb:GetManaCostBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return EPOCH_W_MANA_COST[level + 1]
end

function epoch_genesis_orb:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function epoch_genesis_orb:GetAbilityTargetTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function epoch_genesis_orb:GetAbilityTargetType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function epoch_genesis_orb:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function epoch_genesis_orb:GetAbilitySlot()
    return DOTA_W_SLOT
end

function epoch_genesis_orb:GetCastPoint()
    return 0.2
end

function epoch_genesis_orb:GetCastRange()
    return 1000
end

function epoch_genesis_orb:GetCooldownBase(level)
    return 0
end

function epoch_genesis_orb:GetIntrinsicModifierName()
	return "modifier_epoch_w_passive"
end

function epoch_genesis_orb:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.7})
	EmitSoundOn("Epoch.GenesisOrb.ProjectileCast", caster)
	return true
end

function epoch_genesis_orb:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target = self:GetCastTarget()
    
    self:MainProjectile(caster, target, nil)
    
    Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function epoch_genesis_orb:MainProjectile(source, target, extraData)
	local caster = self:GetCaster()
	local travel_speed = self:GetSpecialValueFor("base_projectile_speed")
	if not extraData then
		local bounces = self:GetSpecialValueFor("max_bounces")
		extraData = {bounces = bounces, speed = travel_speed}
	end
	local info =
	{
		Target = target,
		Source = source,
		Ability = self,
		EffectName = "particles/roshpit/epoch/v2_genesis_orb.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 7,
		bProvidesVision = true,
		iVisionRadius = 100,
		iMoveSpeed = extraData.speed,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = extraData
	}
	projectile = Filters:TrackingProjectile(info)    
end

function epoch_genesis_orb:OnProjectileHit_ExtraData(target, vLocation, extraData)
	local caster = self:GetCaster()
	local damage = self:CalculateImpactDamage()
	if target:HasModifier("modifier_epoch_time_bind") then
		DeepPrintTable(extraData)
		extraData.bounces = extraData.bounces - 1
		extraData[target:GetEntityIndex()] = 1
		extraData.speed = extraData.speed + self:GetSpecialValueFor("projectile_speed_gain")
		local next_target = nil
		local q_ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
		next_target = q_ability:FindNextTargetForW(target, extraData)
		if next_target and extraData.bounces >= 0 then
			self:MainProjectile(target, next_target, extraData)
		end
	end
	EmitSoundOn("Epoch.GenesisOrb.Impact", target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	self:W1()
	self:W3()
end

function epoch_genesis_orb:W1()
	local ability = self
	local caster = self:GetCaster()
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		if not ability.w_1_pfx then
			local particleName = "particles/roshpit/epoch/epoch_a_b_effect.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 80), true)
			ability.w_1_pfx = pfx
		end
		Timers:CreateTimer(1.0, function()
			if ability.w_1_pfx then
				ParticleManager:DestroyParticle(ability.w_1_pfx, true)
				ParticleManager:ReleaseParticleIndex(ability.w_1_pfx)
				ability.w_1_pfx = false
			end
		end)

		local manaRestore = w_1_level * EPOCH_W1_MANA_RESTORE
		caster:GiveMana(manaRestore)
		PopupMana(caster, manaRestore)
	end
end

function epoch_genesis_orb:CalculateImpactDamage()
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*(EPOCH_W2_ATK_POWER_PCT_ADDED_TO_W_DMG/100)*caster:GetRuneValue("w", 2)
	return damage
end

function epoch_genesis_orb:W3()
	local ability = self
	local caster = self:GetCaster()
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		caster:ApplyAndIncrementStackLua(ability, caster, "modifier_epoch_w_3_int", 1, EPOCH_W3_MAX_STACKS, EPOCH_W3_DURATION)
	end	
end

-- PASSIVE

function modifier_epoch_w_passive:IsHidden()
    return true
end

function modifier_epoch_w_passive:RemoveOnDeath()
    return false
end

function modifier_epoch_w_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
    	MODIFIER_ROSHPIT_W_PCT_MANA_COST
    })
end

function modifier_epoch_w_passive:GetRoshpitWBaseAbilityDmgBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("w", 4)*EPOCH_W4_W_BAD/100
end

function modifier_epoch_w_passive:GetRoshpitWPctManaCostModifier()
	local caster = self:GetCaster()
	return caster:GetRuneValue("w", 4)*EPOCH_W4_W_MANA_PCT/100
end

-- W3 INT MODIFIER

function modifier_epoch_w_3_int:IsHidden()
	return false
end

function modifier_epoch_w_3_int:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_INTELLIGENCE_BONUS,
    	MODIFIER_ROSHPIT_EVENT_ATTACK_LAND
    })	
end

function modifier_epoch_w_3_int:GetRoshpitIntelligenceBonus()
	local caster = self:GetCaster()
	return self:GetStackCount()*(caster:GetRuneValue("w", 3)*EPOCH_W3_INT)
end

function modifier_epoch_w_3_int:GetEffectName()
	return "particles/roshpit/epoch/epoch_c_b_buff_amp_damage.vpcf"
end

function modifier_epoch_w_3_int:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_epoch_w_3_int:RoshpitAttackLand()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local w_3_level = caster:GetRuneValue("w", 3)
	local healAmount = math.floor(w_3_level * EPOCH_W3_HEAL)
	Filters:ApplyHeal(caster, caster, healAmount, true)
	-- PopupHealing(caster, healAmount)
	if not ability.w_3_heal_pfx then
		local particleName = "particles/items2_fx/refresher.vpcf"
		local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 80), true)
		ability.w_3_heal_pfx = pfx2
	end
	Timers:CreateTimer(1.0, function()
		if ability.w_3_heal_pfx then
			ParticleManager:DestroyParticle(ability.w_3_heal_pfx, true)
			ParticleManager:ReleaseParticleIndex(ability.w_3_heal_pfx)
			ability.w_3_heal_pfx = false
		end
	end)	
	local new_stacks = self:GetStackCount() - 1
	if new_stacks > 0 then
		self:SetStackCount(new_stacks)
	else
		caster:RemoveModifierByName("modifier_epoch_w_3_int")
	end
end