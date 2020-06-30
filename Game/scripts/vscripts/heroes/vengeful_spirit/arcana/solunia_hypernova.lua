require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
solunia_hypernova = class(base_ability)

modifier_solunia_r_arcana_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_r_arcana_passive", "heroes/vengeful_spirit/arcana/solunia_hypernova.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_r_arcana_channeling = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_r_arcana_channeling", "heroes/vengeful_spirit/arcana/solunia_hypernova.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_falling = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_falling", "heroes/vengeful_spirit/arcana/solunia_hypernova.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_hypernova_warpspeed = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_hypernova_warpspeed", "heroes/vengeful_spirit/arcana/solunia_hypernova.lua", LUA_MODIFIER_MOTION_NONE)


function solunia_hypernova:GetManaCostBase(level)
    return 0
end

function solunia_hypernova:GetBehaviorBase()
	local behavior =  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
	if self:GetCaster():HasModifier("modifier_solunia_immortal_weapon_3") then
		behavior = behavior - DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
	end
	return behavior
end

function solunia_hypernova:GetAbilitySlot()
    return DOTA_R_SLOT
end

function solunia_hypernova:GetCastPoint()
    return 0
end

function solunia_hypernova:GetCooldownBase(level)
	local caster = self:GetCaster()
    return math.max(0, 14 - caster:GetModifierStackCount("modifier_solunia_r_arcana_passive", caster)*SOLUNIA_ARCANA_R4_CD_REDUCE)
end

function solunia_hypernova:GetCastRange()
	local range = 0
	if self:GetCaster():HasModifier("modifier_solunia_immortal_weapon_3") then
		range = SOLUNIA_IMMORTAL_WEAPON_3_CAST_RANGE
	end
    return range
end
function solunia_hypernova:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function solunia_hypernova:GetChannelTimeBase()
	if self:GetCaster():HasModifier("modifier_solunia_immortal_weapon_3") then
    	return 0
	else
		return 1
	end
end

function solunia_hypernova:GetCastAnimation()
    return ACT_DOTA_VERSUS
end

function solunia_hypernova:GetNonArcana2AbilityName()
	return "solunia_supernova_solar"
end

function solunia_hypernova:OnSpellStartBase()
    local caster = self:GetCaster()
    local ability = self
    if self:GetChannelTimeBase() > 0 then
		StartSoundEvent("Solunia.Hypernova.Channel", caster)
		ability.rotationIndex = 0
		ability.startRotation = WallPhysics:vectorToAngle(caster:GetForwardVector())
		caster:AddNewModifier(caster, self, "modifier_solunia_r_arcana_channeling", {duration = self:GetChannelTimeBase()})
	end
	ability.fallVelocity = 1
	caster:RemoveModifierByName("modifier_solunia_between_warp")
end

function solunia_hypernova:OnChannelFinish(interrupted)
	local caster = self:GetCaster()
	local ability = self
	caster:RemoveModifierByName("modifier_solunia_between_warp")
	caster:RemoveModifierByName("modifier_channel_start")
	caster:RemoveModifierByName("modifier_solunia_r_arcana_channeling")
	caster:AddNewModifier(caster, ability, "modifier_solunia_falling", {duration = 2})
	StopSoundEvent("Solunia.Hypernova.Channel", caster)
	if not interrupted then
	    if caster:HasModifier("modifier_solunia_immortal_weapon_3") then
	    	 self:ImmortalWeapon3Movement(self:GetCastPosition())
	    end
		local position = caster:GetAbsOrigin()
		self:MainExplosion(position)
		self:RefreshCooldowns()
		if caster:GetRuneValue("r", 1) > 0 then
			local duration = Filters:GetAdjustedBuffDuration(caster, SOLUNIA_ARCANA_R1_DURATION, false)
			caster:AddNewModifier(caster, ability, "modifier_solunia_hypernova_warpspeed", {duration = duration})
		end
		local q_ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
		if q_ability:GetAbilityName() == "solunia_comet_galactic" then
			caster:RemoveModifierByName(q_ability:GetIntrinsicModifierName())
			caster:AddNewModifier(caster, q_ability, q_ability:GetIntrinsicModifierName(), {})
		end
		Filters:CastSkillArguments(BASE_ABILITY_R, caster)
	end
end

function solunia_hypernova:MainExplosion(position)
	local caster = self:GetCaster()
	local ability = self
	local particleName = "particles/roshpit/solunia/galactic/galactic_supernova.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, -120))
	ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	-- caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	EmitSoundOn("Solunia.Hypernova.Explode", caster)
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetDamage()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, self:GetAbilityDamageType(), BASE_ABILITY_R, self:GetAbilityElement(1), self:GetAbilityElement(2))
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end
	GridNav:DestroyTreesAroundPoint(position, 240, false)
end

function solunia_hypernova:GetAbilityDamageType()
	return DAMAGE_TYPE_PURE
end

function solunia_hypernova:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_FIRE
	end
end


function solunia_hypernova:RefreshCooldowns()
	local caster = self:GetCaster()
	local ability_slots = {DOTA_Q_SLOT, DOTA_W_SLOT, DOTA_E_SLOT}
	for i = 1, #ability_slots, 1 do
		local ability_slot = ability_slots[i]
		local old_ability = caster:GetAbilityByIndex(ability_slot)
		old_ability:EndCooldown()
	end
end


function solunia_hypernova:GetIntrinsicModifierName()
	return "modifier_solunia_r_arcana_passive"
end

function solunia_hypernova:GetDamage()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("all_attributes_damage")*caster:GetSumOfAllAttributes()
end

function solunia_hypernova:InitGalacticForm()
	local caster = self:GetCaster()

	local ability_slots = {DOTA_Q_SLOT, DOTA_W_SLOT, DOTA_E_SLOT}
	for i = 1, #ability_slots, 1 do
		local ability_slot = ability_slots[i]
		local old_ability = caster:GetAbilityByIndex(ability_slot)
		local galactic_ability_name = old_ability:GetGalacticName()

		local modifier_name_to_remove = old_ability:GetIntrinsicModifierName()
		if modifier_name_to_remove then
			caster:RemoveModifierByName(modifier_name_to_remove)
		end

		CustomAbilities:AddAndOrSwapSkill(caster, old_ability:GetAbilityName(), galactic_ability_name, ability_slot)

		local new_ability = caster:GetAbilityByIndex(ability_slot)
		local modifier_name_swap = new_ability:GetIntrinsicModifierName()
		if modifier_name_swap then
			caster:AddNewModifier(caster, new_ability, modifier_name_swap, {})
		end
	end
end

function solunia_hypernova:EndGalacticForm()
	local caster = self:GetCaster()
	local ability_slots = {DOTA_Q_SLOT, DOTA_W_SLOT, DOTA_E_SLOT}
	for i = 1, #ability_slots, 1 do
		local ability_slot = ability_slots[i]
		local old_ability = caster:GetAbilityByIndex(ability_slot)

		local modifier_name_to_remove = old_ability:GetIntrinsicModifierName()
		if modifier_name_to_remove then
			caster:RemoveModifierByName(modifier_name_to_remove)
		end

		local solar_ability_name = old_ability:GetSolarAbilityName()
		CustomAbilities:AddAndOrSwapSkill(caster, old_ability:GetAbilityName(), solar_ability_name, ability_slot)

		local new_ability = caster:GetAbilityByIndex(ability_slot)
		local modifier_name_swap = new_ability:GetIntrinsicModifierName()
		if not caster:HasModifier(modifier_name_swap) then
			if modifier_name_swap then
				caster:AddNewModifier(caster, new_ability, modifier_name_swap, {})
			end
		end
	end
end

function solunia_hypernova:ImmortalWeapon3Movement(position)
	local caster = self:GetCaster()
	local search_position = WallPhysics:WallSearch(caster:GetAbsOrigin(), position, caster)
	local new_position = Vector(search_position.x, search_position.y, caster:GetAbsOrigin().z)
	caster:SetAbsOrigin(new_position)
end

function solunia_hypernova:Glyph5a()
	self.cast_position_override = self:GetCaster():GetAbsOrigin()
	self:OnChannelFinish(false)
end

function solunia_hypernova:GetWaveProjectileName()
	return "particles/roshpit/solunia/galactic/a_a_wave_galactic_2.vpcf"
end

-- PASSIVE

function modifier_solunia_r_arcana_passive:IsHidden()
	return true
end

function modifier_solunia_r_arcana_passive:RemoveOnDeath()
	return false
end

function modifier_solunia_r_arcana_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	RPC_ELEMENT_COSMOS,
    	MODIFIER_ROSHPIT_STRENGTH_PCT_BONUS,
    	MODIFIER_ROSHPIT_AGILITY_PCT_BONUS,
    	MODIFIER_ROSHPIT_INTELLIGENCE_PCT_BONUS,
    	MODIFIER_ROSHPIT_SPIRIT_PCT_BONUS,
    })
	self:StartIntervalThink(1)
	self:GetAbility():InitGalacticForm()
end

function modifier_solunia_r_arcana_passive:OnRemoved()
	if not IsServer() then
		return false
	end
	self:GetAbility():EndGalacticForm()
end

function modifier_solunia_r_arcana_passive:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function modifier_solunia_r_arcana_passive:StatusEffectPriority()
	return 10
end

function modifier_solunia_r_arcana_passive:GetRoshpitElementalDmgBonus()
	return self:GetCaster():GetRuneValue("r", 4)*SOLUNIA_ARCANA_R4_COSMIC_AMP/100
end

function modifier_solunia_r_arcana_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:SetStackCount(self:GetCaster():GetRuneValue("r", 4))
	self:GetParent():SetStatsForLevel()
end

function modifier_solunia_r_arcana_passive:GetRoshpitStrengthPctBonus()
	return self:GetCaster():GetRuneValue("r", 3)*SOLUNIA_ARCANA_R3_ATTR_PCT
end

function modifier_solunia_r_arcana_passive:GetRoshpitAgilityPctBonus()
	return self:GetCaster():GetRuneValue("r", 3)*SOLUNIA_ARCANA_R3_ATTR_PCT
end

function modifier_solunia_r_arcana_passive:GetRoshpitIntelligencePctBonus()
	return self:GetCaster():GetRuneValue("r", 3)*SOLUNIA_ARCANA_R3_ATTR_PCT
end

function modifier_solunia_r_arcana_passive:GetRoshpitSpiritPctBonus()
	return self:GetCaster():GetRuneValue("r", 3)*SOLUNIA_ARCANA_R3_ATTR_PCT
end


-- CHANNELING MODIFIER

function modifier_solunia_r_arcana_channeling:IsHidden()
	return true
end

function modifier_solunia_r_arcana_channeling:OnCreated()
	if not IsServer() then
		return false
	end
	self:CreateRoshpitModifierParticle()
	self:StartIntervalThink(0.03)
end

function modifier_solunia_r_arcana_channeling:SetRoshpitParticleControlPoints(pfx)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), self:GetEffectAttachType(), self:GetRoshpitParticleAttachPoint(), self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), self:GetEffectAttachType(), self:GetRoshpitParticleAttachPoint(), self:GetParent():GetAbsOrigin(), true)
end

function modifier_solunia_r_arcana_channeling:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

	-- if caster:HasModifier("modifier_solunia_in_between_flare") then
	-- 	return false
	-- end
	-- local rotation = ability.rotationIndex * 6 + ability.startRotation
	-- caster:SetAngles(0, rotation, 0)
	local verticalMotion = Vector(0, 0, 0.7)
	local distanceFromGround =caster:GetDistanceFromGround()
	if distanceFromGround > 500 then
		verticalMotion = Vector(0,0,0)
	elseif distanceFromGround > 600 then
		verticalMotion = Vector(0,0,-1)
	elseif distanceFromGround > 700 then
		verticalMotion = Vector(0,0,-2)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + verticalMotion + Vector(0, 0, math.sin(math.pi * ability.rotationIndex / 20) * 6))
	if distanceFromGround >= SOLUNIA_R_HEIGHT_FOR_ATTACK_IMMUNE then
		ability.above_ground_immunity = true
	else
		ability.above_ground_immunity = true
	end
	ability.rotationIndex = ability.rotationIndex + 1
	if caster:HasModifier("modifier_solunia_glyph_2_2") and ability.rotationIndex%17 == 1 then
		caster:FindModifierByName("modifier_solunia_glyph_2_2"):GlyphChannelThink(ability)
	end
	if caster:HasModifier("modifier_solunia_glyph_4_2") and ((ability.rotationIndex)%(SOLUNIA_GLYPH_4_2_BOMB_INTERVAL/0.03)) == 1 then
		caster:FindModifierByName("modifier_solunia_glyph_4_2"):MeteorShower()
	end
end

function modifier_solunia_r_arcana_channeling:GetRoshpitParticleName()
	return "particles/roshpit/solunia/galactic/galactic_channel_supernova.vpcf"
end

function modifier_solunia_r_arcana_channeling:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_solunia_r_arcana_channeling:GetRoshpitParticleAttachPoint()
	return "attach_hitloc"
end

function modifier_solunia_r_arcana_channeling:OnDestroy()
	if not IsServer() then
		return false
	end
	self:DestroyRoshpitModifierParticle()
	self:GetAbility().above_ground_immunity = false
end

function modifier_solunia_r_arcana_channeling:CheckState()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = ability.above_ground_immunity,
		[MODIFIER_STATE_MAGIC_IMMUNE] = ability.above_ground_immunity
	}
	return state
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
    if caster:HasModifier("modifier_solunia_r_arcana_channeling") then
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

-- R1 MODIFIER

function modifier_solunia_hypernova_warpspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_solunia_hypernova_warpspeed:GetModifierMoveSpeedBonus_Constant()
	if not IsServer() then
		return false
	end
	return self:GetCaster():GetRuneValue("r", 1)*SOLUNIA_ARCANA_R1_MS
end

function modifier_solunia_hypernova_warpspeed:GetModifierMoveSpeed_Max_Increase(params)
	if not IsServer() then
		return false
	end
	return self:GetCaster():GetRuneValue("r", 1)*SOLUNIA_ARCANA_R1_MAX_MS
end

function modifier_solunia_hypernova_warpspeed:GetEffectName()
	return "particles/roshpit/solunia/alpha_spark.vpcf"
end

function modifier_solunia_hypernova_warpspeed:GetEffectAttachType()
	return "attach_hitloc"
end

function modifier_solunia_hypernova_warpspeed:GetTexture()
	return "solunia/solunia_rune_r_1_arcana2"
end