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
	local behavior =  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
	if self:GetCaster():HasModifier("modifier_solunia_immortal_weapon_3") then
		behavior = behavior - DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
	end
	return behavior
end

function supernova_base:GetAbilitySlot()
    return DOTA_R_SLOT
end

function supernova_base:GetCastPoint()
    return 0
end

function supernova_base:GetCooldownBase(level)
	local caster = self:GetCaster()
    return math.max(0, 14 - caster:GetModifierStackCount("modifier_solunia_r_passive", caster)*SOLUNIA_R4_CD_REDUCE)
end

function supernova_base:GetCastRange()
	local range = 0
	if self:GetCaster():HasModifier("modifier_solunia_immortal_weapon_3") then
		range = SOLUNIA_IMMORTAL_WEAPON_3_CAST_RANGE
	end
    return range
end

function supernova_base:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function supernova_base:GetChannelTimeBase()
	if self:GetCaster():HasModifier("modifier_solunia_immortal_weapon_3") then
    	return 0
	else
		return 3
	end
end

function supernova_base:GetCastAnimation()
    return ACT_DOTA_VICTORY
end

function supernova_base:SuperNovaChannelStart()
    local caster = self:GetCaster()
    local ability = self
    if self:GetChannelTimeBase() > 0 then
		StartSoundEvent("Solunia.Supernova", caster)
		ability.rotationIndex = 0
		ability.startRotation = WallPhysics:vectorToAngle(caster:GetForwardVector())
		caster:AddNewModifier(caster, self, "modifier_solunia_r_channeling", {duration = self:GetChannelTimeBase()})
	end
	ability.fallVelocity = 1
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
	    if caster:HasModifier("modifier_solunia_immortal_weapon_3") then
	    	 self:ImmortalWeapon3Movement(self:GetCastPosition())
	    end
		local position = caster:GetAbsOrigin()
		self:MainExplosion(position)
		self:SoluniaStateSwap()
		self:RuneR1Cooldowns()
		Filters:CastSkillArguments(BASE_ABILITY_R, caster)
	end
end

function supernova_base:MainExplosion(position)
	local caster = self:GetCaster()
	local ability = self
	local particleName = self:GetMainExplosionParticleName()
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local r_2_level = caster:GetRuneValue("r", 2)
	ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, -120))
	ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	-- caster:RemoveModifierByName("modifier_solunia_ulti_above_ground")
	EmitSoundOn("Solunia.Supernova.Explode", caster)
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetDamage()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, self:GetAbilityDamageType(), BASE_ABILITY_R, self:GetAbilityElement(1), self:GetAbilityElement(2))
			Filters:ApplyStun(caster, stun_duration, enemy)
			if r_2_level > 0 then
				enemy:AddNewModifier(caster, ability, self:GetDualBurnModifierName(), {duration = SOLUNIA_R2_DUAL_BURN_DURATION})
			end
		end
	end
	GridNav:DestroyTreesAroundPoint(position, 240, false)
end

function supernova_base:SoluniaStateSwap()
	local caster = self:GetCaster()
	local ability_slots = {DOTA_Q_SLOT, DOTA_W_SLOT, DOTA_E_SLOT, DOTA_R_SLOT}
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
		if not caster:HasModifier(modifier_name_swap) then
			if modifier_name_swap then
				caster:AddNewModifier(caster, new_ability, modifier_name_swap, {})
			end
		end
	end
end


function supernova_base:GetIntrinsicModifierName()
	return "modifier_solunia_r_passive"
end

function supernova_base:GetDamage()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("all_attributes_damage")*caster:GetSumOfAllAttributes()
end

function supernova_base:RuneR1Cooldowns()
	local caster = self:GetCaster()
	local r_1_level = caster:GetRuneValue("r", 1)
	if r_1_level > 0 then
		local CDReduce = r_1_level*SOLUNIA_R1_CD_REDUCE
		caster:ReduceAllCurrentCooldowns(CDReduce)
	end
end

function supernova_base:GetR2DualBurnDamage(target)
	local caster = self:GetCaster()
	local damage = self:GetDamage()*(SOLUNIA_R2_DUAL_BURN_DMG_PCT_SUPERNOVA*caster:GetRuneValue("r", 2)/100)
	if target:HasModifier(self:GetAlternateDualBurnModifierName()) then
		damage = damage * SOLUNIA_R2_DUAL_BURN_MULT 
	end
	return damage
end

function supernova_base:GetArcana2AbilityName()
	return "solunia_hypernova"
end

function supernova_base:ImmortalWeapon3Movement(position)
	local caster = self:GetCaster()
	local search_position = WallPhysics:WallSearch(caster:GetAbsOrigin(), position, caster)
	local new_position = Vector(search_position.x, search_position.y, caster:GetAbsOrigin().z)
	caster:SetAbsOrigin(new_position)
end

function supernova_base:Glyph5a()
	self.cast_position_override = self:GetCaster():GetAbsOrigin()
	self:SuperNovaChannelFinish(false)
end

-- PASSIVE

function modifier_solunia_r_passive:IsHidden()
	return true
end

function modifier_solunia_r_passive:RemoveOnDeath()
	return false
end

function modifier_solunia_r_passive:OnCreated()
	if not IsServer() then
		return false
	end
	if self:GetAbility() then
		if self:GetAbility():IsSoluniaState(SOLUNIA_STATE_SOLAR) then
		    self:SetSpecialTypes({ 
		    	MODIFIER_ROSHPIT_AGILITY_BONUS,
		    	RPC_ELEMENT_COSMOS,
		    	MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS
		    })
		elseif self:GetAbility():IsSoluniaState(SOLUNIA_STATE_LUNAR) then
		    self:SetSpecialTypes({ 
		    	MODIFIER_ROSHPIT_INTELLIGENCE_BONUS,
		    	RPC_ELEMENT_COSMOS,
		    	MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS
		    })
		end
	end
	self:StartIntervalThink(1)
end

function modifier_solunia_r_passive:GetRoshpitRBaseAbilityDmgBonus()
	return self:GetCaster():GetRuneValue("r", 1)*SOLUNIA_R1_R_BAD/100
end

function modifier_solunia_r_passive:GetRoshpitAgilityBonus()
	return self:GetCaster():GetRuneValue("r", 3)*SOLUNIA_R3_ATTRIBUTE_BONUS
end

function modifier_solunia_r_passive:GetRoshpitIntelligenceBonus()
	return self:GetCaster():GetRuneValue("r", 3)*SOLUNIA_R3_ATTRIBUTE_BONUS
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

function modifier_solunia_r_passive:GetRoshpitElementalDmgBonus()
	return self:GetCaster():GetRuneValue("r", 4)*SOLUNIA_R4_COSMIC_AMP/100
end

function modifier_solunia_r_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:SetStackCount(self:GetCaster():GetRuneValue("r", 4))
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
	local verticalMotion = Vector(0, 0, 2)
	local distanceFromGround =caster:GetDistanceFromGround()
	if distanceFromGround > 500 then
		verticalMotion = Vector(0,0,0)
	elseif distanceFromGround > 600 then
		verticalMotion = Vector(0,0,-1)
	elseif distanceFromGround > 700 then
		verticalMotion = Vector(0,0,-2)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + verticalMotion + Vector(0, 0, math.sin(math.pi * ability.rotationIndex / 30) * 6))
	if distanceFromGround >= SOLUNIA_R_HEIGHT_FOR_ATTACK_IMMUNE then
		ability.above_ground_immunity = true
	else
		ability.above_ground_immunity = true
	end
	ability.rotationIndex = ability.rotationIndex + 1
	if caster:HasModifier("modifier_solunia_glyph_2_2") and ability.rotationIndex%34 == 1 then
		caster:FindModifierByName("modifier_solunia_glyph_2_2"):GlyphChannelThink(ability)
	end
	if caster:HasModifier("modifier_solunia_glyph_4_2") and ((ability.rotationIndex)%(SOLUNIA_GLYPH_4_2_BOMB_INTERVAL/0.03)) == 1 then
		caster:FindModifierByName("modifier_solunia_glyph_4_2"):MeteorShower()
	end
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
	self:GetAbility().above_ground_immunity = false
end

function modifier_solunia_r_channeling:CheckState()
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