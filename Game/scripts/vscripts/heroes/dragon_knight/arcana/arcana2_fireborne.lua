require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_fireborne = class(base_ability)

modifier_flamewaker_arcana_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_arcana_w_passive", "heroes/dragon_knight/arcana/arcana2_fireborne.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_arcana_fireborne = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_arcana_fireborne", "heroes/dragon_knight/arcana/arcana2_fireborne.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_fireborne_shield = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_fireborne_shield", "heroes/dragon_knight/arcana/arcana2_fireborne.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_fireborne_armor_shred = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_fireborne_armor_shred", "heroes/dragon_knight/arcana/arcana2_fireborne.lua", LUA_MODIFIER_MOTION_NONE)

function flamewaker_fireborne:GetManaCostBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return FLAMEWAKER_ARCANA2_W_MANA_COST[level + 1]
end

function flamewaker_fireborne:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function flamewaker_fireborne:GetAbilitySlot()
    return DOTA_W_SLOT
end

function flamewaker_fireborne:GetCastPoint()
    return 0
end

function flamewaker_fireborne:GetCooldownBase(level)
    return 0
end

function flamewaker_fireborne:IsToggle()
    return true
end

function flamewaker_fireborne:OnToggle()
    if IsServer() then
    	if self:GetToggleState() then
    		self:ToggleOn()
    	else
    		self:ToggleOff()
    	end
    end
end

function flamewaker_fireborne:ToggleOn()
	local caster = self:GetCaster()
	local ability = self
	self.frozen = false
	self.sound_started = false
	caster:AddNewModifier(caster, self, "modifier_flamewaker_arcana_fireborne", {})
	self.activation_time = GameRules:GetGameTime()
	StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.5, translate = "iron"})
	ability.flame = false

	if not ability.soundLock then
		ability.soundLock = true
		EmitSoundOn("Flamewaker.Dragonfire.Start.Vo", caster)
		Timers:CreateTimer(2, function()
			ability.soundLock = false
		end)
	end
end

function flamewaker_fireborne:ToggleOff()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_flamewaker_arcana_fireborne")
	local ability = self
	if ability.flame then
		for i = 0, 2, 1 do
			Timers:CreateTimer(0.1 * i, function()
				local fv = caster:GetForwardVector()
				for j = -1, 1, 1 do
					local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * j / 16)
					ability:FireborneProjectile(caster, ability, 1600, rotatedFV, ability.movespeed)
				end
			end)
		end
	end
	ability.flame = false
	StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.3, translate = "iron"})
	Timers:CreateTimer(0.1, function()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
		StopSoundEvent("Flamewaker.Dragonfire.LP", caster)
		EmitSoundOn("Flamewaker.Dragonfire.Fire", caster)
	end)
	if not ability.soundLock then
		EmitSoundOn("Flamewaker.Dragonfire.End.Vo", caster)
	end
	local sticky_duration = caster:GetRuneValue("w", 1)*FLAMEWAKER_ARCANA2_W1_SHIELD_STICKY
	if sticky_duration > 0 and caster:HasModifier("modifier_flamewaker_fireborne_shield") then
		caster:AddNewModifier(caster, ability, "modifier_flamewaker_fireborne_shield", {duration = sticky_duration})
	else
		caster:RemoveModifierByName("modifier_flamewaker_fireborne_shield")
	end

end

function flamewaker_fireborne:FireborneProjectile(caster, ability, range, fv, pullback)
	local projectileParticle = "particles/roshpit/flamewaker/dragonfire.vpcf"
	if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		projectileParticle = "particles/roshpit/flamewaker/arcana/bluedragon.vpcf"
	end
	local projectileOrigin = caster:GetAbsOrigin()
	local start_radius = 320
	local end_radius = 320
	local speed = 1200
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectileOrigin + Vector(0, 0, 20) + fv * pullback,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	Filters:LinearProjectile(info)
end

function flamewaker_fireborne:OnProjectileHit(target, vLoc)
	local caster = self:GetCaster()
	local ability = self
	if target then
		local base_damage = self:GetSpecialValueFor("base_damage")
		local attack_dmg_bonus = 0
		local w_3_level = caster:GetRuneValue("w", 3)
		attack_dmg_bonus = attack_dmg_bonus + w_3_level * FLAMEWAKER_ARCANA2_W3_ATK_POWER_ADDED_TO_FLAME
		local damage = base_damage + (attack_dmg_bonus / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster)
		-- if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		-- 	damage = damage + ((caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() + caster:GetSpirit()) * FLAMEWAKER_GLYPH_4_1_ATTIRIBUTES_TO_W_DAMAGE_PER_LVL) * ability:GetLevel()
		-- end
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)

		local shred_duration = ability:GetSpecialValueFor("armor_shred_duration")
		target:ApplyAndIncrementStackLua(self, self:GetCaster(), "modifier_flamewaker_fireborne_armor_shred", 1, FLAMEWAKER_ARCANA2_W_MAX_ARMOR_SHRED_STACKS, shred_duration)
		target:CalculateAndSaveRoshpitAttributes()
	end
	return false
end

-- MAIN TOGGLE MODIFIER

function modifier_flamewaker_arcana_fireborne:IsHidden()
	return false
end

function modifier_flamewaker_arcana_fireborne:IsBuff()
	return true
end

function modifier_flamewaker_arcana_fireborne:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	    self:SetSpecialTypes({
	    	MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
	    	MODIFIER_ROSHPIT_W_PCT_CD_MOD,
	        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
	        MODIFIER_ROSHPIT_R_PCT_CD_MOD
	    })
	end
end

function modifier_flamewaker_arcana_fireborne:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		if GameRules:GetGameTime() - ability.activation_time >= 0.3 then
			ability.frozen = true
		end
		if GameRules:GetGameTime() - ability.activation_time >= 0.2 then
			if not ability.sound_started then
				ability.sound_started = true
				StartSoundEvent("Flamewaker.Dragonfire.LP", caster)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
				EmitSoundOn("Flamewaker.Dragonfire.Fire", caster)
				ability.flame = true
				Filters:CastSkillArguments(BASE_ABILITY_W, caster)
			end
		end
		local shield_delay = FLAMEWAKER_ARCANA2_W_SHIELD_DELAY + caster:GetRuneValue("w", 1)*FLAMEWAKER_ARCANA2_W1_SHIELD_DELAY
		if GameRules:GetGameTime() - ability.activation_time >= shield_delay then
			caster:AddNewModifier(caster, ability, "modifier_flamewaker_fireborne_shield", {})
		end

		local mana_drain = ability:GetManaCost(-1)/10
		if not ability.fv then
			ability.fv = caster:GetForwardVector()
		end

		if ability.flame then
			if not ability.movespeed then
				ability.movespeed = 0
				ability.lastPos = caster:GetAbsOrigin()
			end
			if not ability.interval then
				ability.interval = 0
			end
			ability.fv = WallPhysics:rotateVector(ability.fv, 2 * math.pi / 30)
			local fv = caster:GetForwardVector()
			ability.interval = ability.interval + 1
			ability.movespeed = WallPhysics:GetDistance2d(ability.lastPos, caster:GetAbsOrigin()) / 0.5 + 120
			local distance = 280 + caster:GetRuneValue("w", 3)*FLAMEWAKER_ARCANA2_W3_RANGE
			for i = -1, 1, 1 do
				local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / 16)
				ability:FireborneProjectile(caster, ability, distance, rotatedFV, ability.movespeed)
			end
			ability.lastPos = caster:GetAbsOrigin()
			if ability.interval % 5 == 0 then
				Filters:CastSkillArguments(BASE_ABILITY_W, caster)
			end
			if ability.interval > 90 then
				ability.interval = 0
			end
			if caster:GetMana() > mana_drain then
				caster:ReduceMana(mana_drain)
			else
				ability:ToggleAbility()
			end
		end
	end
end

function modifier_flamewaker_arcana_fireborne:CheckState()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	local state = {
		[MODIFIER_STATE_FROZEN] = ability.frozen,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

function modifier_flamewaker_arcana_fireborne:GetRoshpitQPctCdModifier()
	local reduce = self:GetCaster():GetRuneValue("w", 4)*FLAMEWAKER_ARCANA2_W4_CD_REDUCTION
	reduce = -reduce/100
    return reduce
end

function modifier_flamewaker_arcana_fireborne:GetRoshpitWPctCdModifier()
	local reduce = self:GetCaster():GetRuneValue("w", 4)*FLAMEWAKER_ARCANA2_W4_CD_REDUCTION
	reduce = -reduce/100
    return reduce
end

function modifier_flamewaker_arcana_fireborne:GetRoshpitEPctCdModifier()
	local reduce = self:GetCaster():GetRuneValue("w", 4)*FLAMEWAKER_ARCANA2_W4_CD_REDUCTION
	reduce = -reduce/100
    return reduce
end

function modifier_flamewaker_arcana_fireborne:GetRoshpitRPctCdModifier()
	local reduce = self:GetCaster():GetRuneValue("w", 4)*FLAMEWAKER_ARCANA2_W4_CD_REDUCTION
	reduce = -reduce/100
    return reduce
end

-- SHIELD MODIFIER

function modifier_flamewaker_fireborne_shield:IsHidden()
	return false
end

function modifier_flamewaker_fireborne_shield:OnCreated()
	if not IsServer() then
		return false
	end
	local caster = self:GetParent()
	local ability = self:GetAbility()
	EmitSoundOn("Flamewaker.Dragonfire.ShieldApply", caster)
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_PURE_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MASTER_HEALTH_REGEN,
        MODIFIER_ROSHPIT_ARMOR_BONUS 
    })	
    if caster:GetRuneValue("w", 2) > 0 then
		if ability.shimmer_pfx then
			ParticleManager:DestroyParticle(ability.shimmer_pfx, false)
		end
		local pfx = ParticleManager:CreateParticle("particles/roshpit/flamewaker/fireborne_shimmer_heal.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ability.shimmer_pfx = pfx
    end
end

function modifier_flamewaker_fireborne_shield:OnRemoved()
	local ability = self:GetAbility()
	if ability.shimmer_pfx then
		ParticleManager:DestroyParticle(ability.shimmer_pfx, false)
		ability.shimmer_pfx = nil
	end
end

function modifier_flamewaker_fireborne_shield:GetRoshpitArmorBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("w", 2)*FLAMEWAKER_ARCANA2_W2_ARMOR
end

function modifier_flamewaker_fireborne_shield:GetRoshpitMasterHealthRegen()
	local caster = self:GetCaster()
	return caster:GetRuneValue("w", 2)*FLAMEWAKER_ARCANA2_W2_HEALTH_REGEN
end

function modifier_flamewaker_fireborne_shield:GetPhysicalDamageReduction()
	return self:GetAbility():GetSpecialValueFor("damage_reduce")/100
end

function modifier_flamewaker_fireborne_shield:GetMagicalDamageReduction()
	return self:GetAbility():GetSpecialValueFor("damage_reduce")/100
end

function modifier_flamewaker_fireborne_shield:GetPureDamageReduction()
	return self:GetAbility():GetSpecialValueFor("damage_reduce")/100
end

function modifier_flamewaker_fireborne_shield:GetEffectName()
	return "particles/roshpit/flamewaker/dragon_shield.vpcf"
end

function modifier_flamewaker_fireborne_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_flamewaker_fireborne_shield:GetTexture()
	return "flamewaker/flamewaker_rune_w_2_arcana2"
end

-- ARMOR SHRED MODIFIER

function modifier_flamewaker_fireborne_armor_shred:IsHidden()
	return false
end

function modifier_flamewaker_fireborne_armor_shred:IsDebuff()
	return true
end

function modifier_flamewaker_fireborne_armor_shred:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_BONUS
    })
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_flamewaker_fireborne_armor_shred:OnRemoved()
	if not IsServer() then
		return false
	end
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end


function modifier_flamewaker_fireborne_armor_shred:GetRoshpitArmorBonus()
	local armor_reduction = self:GetStackCount() * self:GetAbility():GetSpecialValueFor("armor_shred")
	return armor_reduction
end
