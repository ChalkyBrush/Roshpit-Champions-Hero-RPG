require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
warp_flare_base = class(base_ability)

modifier_solunia_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_e_passive", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_warp_flare = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_warp_flare", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_between_warp = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_between_warp", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_warp_flare_e1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_warp_flare_e1", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_warp_flare_e2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_warp_flare_e2", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_warp_flare_e2_debuff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_warp_flare_e2_debuff", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

function warp_flare_base:GetManaCostBase(level)
    return 0
end

function warp_flare_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solunia_warp_flare_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solunia_warp_flare_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	elseif self:GetAbilityName() == "solunia_warp_flare_galactic" and state == SOLUNIA_STATE_GALACTIC then
		return true
	else
		return false
	end
end

function warp_flare_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function warp_flare_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function warp_flare_base:GetAbilitySlot()
    return DOTA_E_SLOT
end

function warp_flare_base:GetCastPoint()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_solunia_warp_flare") then
		return 0
	else
    	return 0.26
    end
end

function warp_flare_base:GetInBetweenFloatTime()
	return SOLUNIA_E_FLOAT_TIME
end

-- function warp_flare_base:GetCastRange()
--     return self:GetSpecialValueFor("range")
-- end

function warp_flare_base:GetCooldownBase(level)
    return 13
end

function warp_flare_base:GetIntrinsicModifierName()
	return "modifier_solunia_e_passive"
end

function warp_flare_base:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	EmitSoundOn("Selethas.Throw.VO", caster)

	return true
end

function warp_flare_base:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCastPosition()

    if not ability.warp_count then
    	ability.warp_count = 0
    end
    if ability.warp_count == 0 then
		ability.travel_data = {}
	end
	caster:AddNewModifier(caster, ability, "modifier_solunia_warp_flare", {})
	ability:WarpToPosition(target_position)

    Filters:CastSkillArguments(BASE_ABILITY_E, caster)
    ability:EndCooldown()
end

function warp_flare_base:GetMaxWarpDistance()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("cast_range") + caster:GetModifierStackCount("modifier_solunia_e_passive", caster)*SOLUNIA_E4_CAST_RANGE
end

function warp_flare_base:GetMaxWarpCount()
	local caster = self:GetCaster()
	local base_count = 3
	if caster:HasModifier("modifier_solunia_immortal_weapon_2") then
		base_count = base_count + 1
	end
	if caster:HasModifier("modifier_solunia_glyph_6_1") then
		base_count = base_count + 1
	end
	return base_count
end

function warp_flare_base:GetActualCastPosition(position)
	local caster = self:GetCaster()
	local warp_distance = math.min(WallPhysics:GetDistance2d(caster:GetAbsOrigin(), position), self:GetMaxWarpDistance())
	local fv = ((position - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local pos = caster:GetAbsOrigin() + fv*warp_distance
	return GetGroundPosition(pos, caster)
end

function warp_flare_base:WarpToPosition(position)
    local ability = self
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_solunia_between_warp")
	caster:RemoveModifierByName("modifier_solunia_falling")
	-- ability:SetActivated(false)

	EmitSoundOn("Solunia.WarpFlare", caster)
	ability.warp_count = ability.warp_count + 1
	if ability.warp_count > 0 then
		StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.6})
	end
	local travel_obj = {}
	local warp_distance = math.min(WallPhysics:GetDistance2d(caster:GetAbsOrigin(), position), self:GetMaxWarpDistance())

	travel_obj["start_position"] = caster:GetAbsOrigin()
	travel_obj["fv"] = ((position - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	travel_obj["target_position"] = travel_obj["start_position"] + travel_obj["fv"]*warp_distance
	travel_obj["distance_travelled"] = 0
	travel_obj["distance_goal"] = WallPhysics:GetDistance2d(travel_obj["start_position"], travel_obj["target_position"])
	travel_obj["pfx"] = ParticleManager:CreateParticle(self:GetTravelBandPFXName(), PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(travel_obj["pfx"], 0, travel_obj["start_position"])

	local angle = WallPhysics:vectorToAngle(travel_obj["fv"])
	caster:SetAngles(0, angle, 0)
	table.insert(ability.travel_data, travel_obj)
end

function warp_flare_base:WarpTravelEnd()
	local ability = self
	local caster = self:GetCaster()
	-- ability:SetActivated(true)
	self:TravelEndParticle()
	if ability.warp_count < self:GetMaxWarpCount() then
		local between_warp_time = SOLUNIA_E_FLOAT_TIME
		if caster:HasModifier("modifier_solunia_immortal_weapon_2") then
			between_warp_time = between_warp_time + SOLUNIA_IMMORTAL_WEAPON_2_FLOAT_DURATION_INCREASE
		end
		ability.startRotation = WallPhysics:vectorToAngle(caster:GetForwardVector())
		caster:AddNewModifier(caster, ability, "modifier_solunia_between_warp", {duration = between_warp_time})
	else
		self:EndWarpFlare()
	end
	self:RuneE2()

	caster:RemoveModifierByName("modifier_solunia_warp_flare")

	self:Glyph1_2()
end

function warp_flare_base:TravelEndParticle()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle(self:GetTravelEndParticle(), PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	EmitSoundOn("Solunia.WarpExplosion", caster)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function warp_flare_base:EndWarpFlare()
	local ability = self
	local caster = self:GetCaster()
	if ability.warp_count == self:GetMaxWarpCount() and caster:HasModifier("modifier_solunia_glyph_5_a") then
		caster:GetAbilityByIndex(DOTA_R_SLOT):Glyph5a()
	end
	ability.warp_count = 0
	ability:StartCooldown(ability:GetCooldownBase())
	local r_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
	r_ability.fallVelocity = 1
	caster:AddNewModifier(caster, r_ability, "modifier_solunia_falling", {})
	for i = 1, #ability.travel_data, 1 do
		ParticleManager:DestroyParticle(ability.travel_data[i]["pfx"], false)
		ParticleManager:ReleaseParticleIndex(ability.travel_data[i]["pfx"])
	end
	StartAnimation(caster, {duration = 0.25, activity = ACT_DOTA_CHANNEL_END_ABILITY_4, rate = 2})
	caster:RemoveModifierByName("modifier_solunia_warp_flare_e1")

end

function warp_flare_base:RuneE2()
	local caster = self:GetCaster()
	if caster:GetRuneValue("e", 2) > 0 then
		local ability = self
		local position = GetGroundPosition(caster:GetAbsOrigin(), caster)
		local duration = SOLUNIA_E2_PAD_DURATION
		local radius = self:GetE2Radius()
		local pfx = CustomAbilities:QuickParticleAtPoint(self:GetE2ParticleName(), position, duration)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 240))
		ParticleManager:SetParticleControl(pfx, 2, Vector(duration, duration, duration))
		Util.Ability:MakeThinker(caster, ability, "modifier_solunia_warp_flare_e2", position, duration)
	end
end

function warp_flare_base:GetE2Radius()
	return SOLUNIA_E2_PAD_RADIUS
end

function warp_flare_base:GetWarpingSpeed()
	local caster = self:GetCaster()
	return SOLUNIA_E_TRAVEL_SPEED * ((1 + (caster:GetRuneValue("e", 4)*SOLUNIA_E4_WARPSPEED_PCT)/100))
end

function warp_flare_base:GetGalacticName()
	return "solunia_warp_flare_galactic"
end

function warp_flare_base:Glyph1_2()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_solunia_glyph_1_2") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, SOLUNIA_GLYPH_1_2_ATTACK_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
			end
		end
	end
end

-- PASSIVE

function modifier_solunia_e_passive:IsHidden()
	return true
end

function modifier_solunia_e_passive:RemoveOnDeath()
	return false
end

function modifier_solunia_e_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS
    })
    self:StartIntervalThink(1)
end

function modifier_solunia_e_passive:GetFlatHealthBonus()
	return self:GetCaster():GetRuneValue("e", 3)*SOLUNIA_E3_HEALTH_BONUS
end

function modifier_solunia_e_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:SetStackCount(self:GetCaster():GetRuneValue("e", 4))
end

-- WARP FLARE MODIFIER

function modifier_solunia_warp_flare:IsHidden()
	return false
end

function modifier_solunia_warp_flare:IsBuff()
	return true
end

function modifier_solunia_warp_flare:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}

	return funcs
end

function modifier_solunia_warp_flare:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_solunia_warp_flare:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state	
end

function modifier_solunia_warp_flare:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
	local hero = self:GetParent()
	if hero:GetRuneValue("e", 1) > 0 then
		hero:AddNewModifier(hero, self:GetAbility(), "modifier_solunia_warp_flare_e1", {})
	end
end

function modifier_solunia_warp_flare:OnRemoved()
	if not IsServer() then
		return false
	end
end

function modifier_solunia_warp_flare:OnDestroy()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
end

function modifier_solunia_warp_flare:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()

	local travel_data = ability.travel_data[ability.warp_count]
	if not travel_data then
		return false
	end
	local warp_travel_end = false
	local forwardSpeed = ability:GetWarpingSpeed()
	forwardSpeed = Filters:GetAdjustedESpeed(caster, forwardSpeed, false)
	local liftVector = Vector(0, 0, 0)
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < SOLUNIA_E_MAX_HEIGHT then
		liftVector = Vector(0, 0, SOLUNIA_E_HEIGHT_GAIN)
	end
	local newPos = caster:GetAbsOrigin() + travel_data["fv"] * forwardSpeed + liftVector
	local obstruction = WallPhysics:FindNearestObstruction(newPos)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		forwardSpeed = 0
		warp_travel_end = true
	end
	if travel_data["distance_travelled"] >= travel_data["distance_goal"] then
		warp_travel_end = true
	end
	if warp_travel_end then
		ParticleManager:SetParticleControl(travel_data["pfx"], 1, Vector(travel_data["target_position"].x, travel_data["target_position"].y, caster:GetAbsOrigin().z))
		ability:WarpTravelEnd()
	else
		caster:SetAbsOrigin(newPos)
		travel_data["distance_travelled"] = travel_data["distance_travelled"] + forwardSpeed
		if travel_data["pfx"] then
			ParticleManager:SetParticleControl(travel_data["pfx"], 1, caster:GetAbsOrigin() + Vector(0, 0, 30) + travel_data["fv"] * 60)
		end
	end

end

-- IN BETWEEN WARP MODIFIER

function modifier_solunia_between_warp:IsHidden()
	return false
end

function modifier_solunia_between_warp:IsBuff()
	return true
end

function modifier_solunia_between_warp:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state	
end

function modifier_solunia_between_warp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}

	return funcs
end

function modifier_solunia_between_warp:GetOverrideAnimation()
	return ACT_DOTA_VERSUS
end

function modifier_solunia_between_warp:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_solunia_between_warp:OnCreated()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	ability.floating_interval = 0
	self:StartIntervalThink(0.03)

end

function modifier_solunia_between_warp:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	ability.floating_interval = ability.floating_interval + 1
	caster:SetAngles(0, ability.floating_interval * 0.5 + ability.startRotation, 0)
	caster:SetAbsOrigin(caster:GetAbsOrigin() + math.cos(ability.floating_interval * math.pi / 50) * 1.2)	
end

function modifier_solunia_between_warp:OnDestroy()
	if not IsServer() then
		return false
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster:HasModifier("modifier_solunia_warp_flare") then
		ability:EndWarpFlare()
	end
end

-- E1 Shield

function modifier_solunia_warp_flare_e1:IsHidden()
	return false
end

function modifier_solunia_warp_flare_e1:IsBuff()
	return true
end

function modifier_solunia_warp_flare_e1:GetEffectName()
	if self:GetAbility():IsSoluniaState(SOLUNIA_STATE_SOLAR) then
		return "particles/roshpit/solunia/shooting_star_shield_solar.vpcf"
	elseif self:GetAbility():IsSoluniaState(SOLUNIA_STATE_LUNAR) then
		return "particles/roshpit/solunia/shooting_star_shield.vpcf"
	elseif self:GetAbility():IsSoluniaState(SOLUNIA_STATE_GALACTIC) then
		return "particles/roshpit/solunia/galactic/star_shield_galactic.vpcf"
	end
end

function modifier_solunia_warp_flare_e1:GetEffectAttachType()
	return "attach_hitloc"
end

function modifier_solunia_warp_flare_e1:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_HEALTH_REGEN,
    	MODIFIER_ROSHPIT_ARMOR_BONUS,
    	MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
end

function modifier_solunia_warp_flare_e1:GetRoshpitMasterHealthRegen()
	return self:GetCaster():GetRuneValue("e", 1)*SOLUNIA_E1_HEALTH_REGEN
end

function modifier_solunia_warp_flare_e1:GetRoshpitArmorBonus()
	return self:GetCaster():GetRuneValue("e", 1)*SOLUNIA_E1_ARMORS
end

function modifier_solunia_warp_flare_e1:GetRoshpitMagicArmorBonus()
	return self:GetCaster():GetRuneValue("e", 1)*SOLUNIA_E1_ARMORS
end

function modifier_solunia_warp_flare_e1:GetTexture()
	return "solunia/solunia_rune_e_1"
end

-- E2 Base Modifier

function modifier_solunia_warp_flare_e2:IsHidden()
    return true
end

function modifier_solunia_warp_flare_e2:IsBuff()
    return true
end

function modifier_solunia_warp_flare_e2:IsAura()
    return true
end

function modifier_solunia_warp_flare_e2:IsAuraActiveOnDeath()
    return false
end

function modifier_solunia_warp_flare_e2:GetAuraRadius()
    return self:GetAbility():GetE2Radius()
end

function modifier_solunia_warp_flare_e2:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_solunia_warp_flare_e2:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function modifier_solunia_warp_flare_e2:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_solunia_warp_flare_e2:RemoveOnDeath()
    return false
end

function modifier_solunia_warp_flare_e2:GetModifierAura()
    return "modifier_solunia_warp_flare_e2_debuff"
end

-- E2 DEBUFF

function modifier_solunia_warp_flare_e2_debuff:IsHidden()
	return false
end

function modifier_solunia_warp_flare_e2_debuff:IsDebuff()
	return true
end

function modifier_solunia_warp_flare_e2_debuff:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_MS,
    	MODIFIER_ROSHPIT_ARMOR_BONUS,
    	MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_solunia_warp_flare_e2_debuff:GetRoshpitMasterMS()
	return self:GetAbility():GetCaster():GetRuneValue("e", 2)*SOLUNIA_E2_MS_LOSS
end

function modifier_solunia_warp_flare_e2_debuff:GetRoshpitArmorBonus()
	if self:GetAbility():IsSoluniaState(SOLUNIA_STATE_SOLAR) or self:GetAbility():IsSoluniaState(SOLUNIA_STATE_GALACTIC) then
		return self:GetAbility():GetCaster():GetRuneValue("e", 2)*SOLUNIA_E2_ARMORS_LOSS
	else
		return 0
	end
end

function modifier_solunia_warp_flare_e2_debuff:GetRoshpitMagicArmorBonus()
	if self:GetAbility():IsSoluniaState(SOLUNIA_STATE_LUNAR) or self:GetAbility():IsSoluniaState(SOLUNIA_STATE_GALACTIC) then
		return self:GetAbility():GetCaster():GetRuneValue("e", 2)*SOLUNIA_E2_ARMORS_LOSS
	else
		return 0
	end
end

function modifier_solunia_warp_flare_e2_debuff:OnRemoved()
	if not IsServer() then
		return false
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_solunia_warp_flare_e2:GetTexture()
	return "solunia/solunia_rune_e_2"
end