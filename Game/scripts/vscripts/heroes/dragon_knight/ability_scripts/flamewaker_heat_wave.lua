require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_heat_wave = class(base_ability)

modifier_flamewaker_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_e_passive", "heroes/dragon_knight/ability_scripts/flamewaker_heat_wave.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_e_heat_wave_base = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_e_heat_wave_base", "heroes/dragon_knight/ability_scripts/flamewaker_heat_wave.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_e_heat_wave_e1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_e_heat_wave_e1", "heroes/dragon_knight/ability_scripts/flamewaker_heat_wave.lua", LUA_MODIFIER_MOTION_NONE)

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
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	caster:AddNewModifier(caster, self, "modifier_flamewaker_e_heat_wave_base", {duration = duration})
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
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
    self:StartIntervalThink(0.5)
end

function modifier_flamewaker_e_passive:GetRoshpitArmorPierceBonus()
	local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - FLAMEWAKER_E3_BASE_MS_REQ)
	return ms_over_threshold * FLAMEWAKER_E3_PIERCE_PER_MS_OVER_THRESH * self:GetCaster():GetRuneValue("e", 3)
end

function modifier_flamewaker_e_passive:GetRoshpitMasterBaseDMG()
	local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - FLAMEWAKER_E3_BASE_MS_REQ)
	return ms_over_threshold * FLAMEWAKER_E3_BASE_DMG_PER_MS_OVER_THRESH * self:GetCaster():GetRuneValue("e", 3)
end

function modifier_flamewaker_e_passive:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if ability.e_2_table and #ability.e_2_table > 0 then
		if GameRules:GetGameTime() > ability.e_2_startTime + FLAMEWAKER_E2_DURATION then
			ability:ClearE2Table()
		else
			local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (FLAMEWAKER_E2_DMG_ATK_PWR/100)
			for i = 1, #ability.e_2_table, 1 do
				local position = ability.e_2_table[i].position
			    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, FLAMEWAKER_E2_DISTANCE_TO_CREATE_PUDDLE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			    if #enemies > 0 then
			        for _, enemy in pairs(enemies) do
			            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_clinkz/clinkz_burning_army_ambient.vpcf", enemy, 0.5)
			            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_E, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			        end
			    end
			end
		end
	end
end

function flamewaker_heat_wave:ClearE2Table()
	local ability = self
	if ability.e_2_table and #ability.e_2_table > 0 then
		for i = 1, #ability.e_2_table, 1 do
			ParticleManager:DestroyParticle(ability.e_2_table[i].pfx, false)
		end
	end
	ability.e_2_table = {}
end

-- MAIN MODIFIER

function modifier_flamewaker_e_heat_wave_base:IsHidden()
	return false
end

function modifier_flamewaker_e_heat_wave_base:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_PURE_DMG_REDUCTION
    })	
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil
	end	
	local baseSound = "Flamewaker.HeatWaveCast"
	local lpSound = "Flamewaker.HeatWave.LP"

    caster:RemoveModifierByName("modifier_flamewaker_e_heat_wave_e1")
    local particleName = "particles/roshpit/flamewaker/heat_wave.vpcf"
    if caster:HasModifier("modifier_flamewaker_glyph_2_2") then
    	particleName = "particles/roshpit/flamewaker/blue_heatwave.vpcf"
  		baseSound = "Flamewaker.HeatWaveCast.Glyph"
		lpSound = "Flamewaker.HeatWave.LP.Glyph"
    end
    EmitSoundOn(baseSound, caster)
    StartSoundEvent(lpSound, caster)
    local particleVector = caster:GetAbsOrigin() - (caster:GetForwardVector() * 90)
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true)
    ParticleManager:SetParticleControl(pfx, 1, particleVector + Vector(0, 0, 100))
    ability.pfx = pfx
    ability.allow_terrain_traverse = true
    ability.interval = 0
    ability:ClearE2Table()
    ability.e_2_startTime = GameRules:GetGameTime()
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
    ability.interval = ability.interval + 1
    self:CalculateE1()
    self:CalculateE2()
    if caster:HasModifier("modifier_flamewaker_arcana_fireborne") then
    	local speed = caster:GetActualMovespeed()/100
        local newPos = GetGroundPosition(caster:GetAbsOrigin() + caster:GetForwardVector() * speed, caster) 
        local obstruction = WallPhysics:FindNearestObstruction(newPos)
        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
        if not blockUnit then
            caster:SetAbsOrigin(newPos)
        end
    end
end

function modifier_flamewaker_e_heat_wave_base:CalculateE1()
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if ability.interval%3 == 0 then
		if caster:GetRuneValue("e", 1) > 0 then
			local duration = Filters:GetAdjustedBuffDuration(caster, FLAMEWAKER_E1_DURATION, false)
			caster:AddNewModifier(caster, ability, "modifier_flamewaker_e_heat_wave_e1", {duration = duration})
			local new_stacks = caster:GetModifierStackCount("modifier_flamewaker_e_heat_wave_e1", caster) + 1
			caster:SetModifierStackCount("modifier_flamewaker_e_heat_wave_e1", caster, new_stacks)
		end
	end
end

function modifier_flamewaker_e_heat_wave_base:CalculateE2()
	local ability = self:GetAbility()
	local caster = self:GetParent()
    if ability.interval % 1 == 0 then
    	if caster:GetRuneValue("e", 2) > 0 then
    		local free_space_condition = true
    		for i = 1, #ability.e_2_table, 1 do
    			local free_space_distance_check = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.e_2_table[i].position)
    			if free_space_distance_check < FLAMEWAKER_E2_DISTANCE_TO_CREATE_PUDDLE then
    				free_space_condition = false
    				break
    			end
    		end
    		if free_space_condition then
    			local flame_object = {}
    			flame_object.position = caster:GetAbsOrigin()
    			local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_lava/courier_roshan_lava_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
    			ParticleManager:SetParticleControl(pfx, 0, flame_object.position)
    			ParticleManager:SetParticleControl(pfx, 1, Vector(250, 1, 1))
    			flame_object.pfx = pfx
    			table.insert(ability.e_2_table, flame_object)
    		end
    	end
    end
    if caster:HasModifier("modifier_flamewaker_glyph_7_1") and caster:GetRuneValue("e", 2) > 0 then
	    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FLAMEWAKER_GLYPH_7_1_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	    if #enemies > 0 then
	        for _, enemy in pairs(enemies) do
	    		local free_space_condition = true
	    		for i = 1, #ability.e_2_table, 1 do
	    			local free_space_distance_check = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), ability.e_2_table[i].position)
	    			if free_space_distance_check < FLAMEWAKER_E2_DISTANCE_TO_CREATE_PUDDLE then
	    				free_space_condition = false
	    				break
	    			end
	    		end
	    		if free_space_condition then
	    			local flame_object = {}
	    			flame_object.position = enemy:GetAbsOrigin()
	    			local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_lava/courier_roshan_lava_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    			ParticleManager:SetParticleControl(pfx, 0, flame_object.position)
	    			ParticleManager:SetParticleControl(pfx, 1, Vector(250, 1, 1))
	    			flame_object.pfx = pfx
	    			table.insert(ability.e_2_table, flame_object)
	    		end
	        end
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
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

	local lpSound = "Flamewaker.HeatWave.LP"
	local endSound = "Flamewaker.HeatWave.End"
    if caster:HasModifier("modifier_flamewaker_glyph_2_2") then
		lpSound = "Flamewaker.HeatWave.LP.Glyph"
		endSound = "Flamewaker.HeatWave.End.Glyph"
	end
	StopSoundEvent(lpSound, caster)
	EmitSoundOn(endSound, caster)
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
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_flamewaker_e_heat_wave_base:GetModifierMoveSpeedBonus_Constant()
	local mult = 1
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_flamewaker_glyph_2_2") then
		mult = -1
	end
	return self:GetAbility():GetSpecialValueFor("movespeed")*mult
end

function modifier_flamewaker_e_heat_wave_base:GetModifierMoveSpeed_Max_Increase(params)
	return FLAMEWAKER_E_MS_CAP_BONUS + self:GetCaster():GetRuneValue("e", 4)*FLAMEWAKER_E4_MS_CAP
end

function modifier_flamewaker_e_heat_wave_base:GetPhysicalDamageReduction()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_flamewaker_glyph_2_2") then
		return FLAMEWAKER_GLYPH_2_2_DAMAGE_REDUCTION/100
	else
		return 0
	end
end

function modifier_flamewaker_e_heat_wave_base:GetMagicalDamageReduction()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_flamewaker_glyph_2_2") then
		return FLAMEWAKER_GLYPH_2_2_DAMAGE_REDUCTION/100
	else
		return 0
	end
end

function modifier_flamewaker_e_heat_wave_base:GetPureDamageReduction()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_flamewaker_glyph_2_2") then
		return FLAMEWAKER_GLYPH_2_2_DAMAGE_REDUCTION/100
	else
		return 0
	end
end

-- E1 MODIFIER

function modifier_flamewaker_e_heat_wave_e1:IsHidden()
	return false
end

function modifier_flamewaker_e_heat_wave_e1:RemoveOnDeath()
	return true
end

function modifier_flamewaker_e_heat_wave_e1:IsBuff()
	return true
end

function modifier_flamewaker_e_heat_wave_e1:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_AS,
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
end

function modifier_flamewaker_e_heat_wave_e1:GetRoshpitMasterGreenDMG()
	local caster = self:GetCaster()
	return self:GetStackCount()*FLAMEWAKER_E1_ATK_POWER*caster:GetRuneValue("e", 1)
end

function modifier_flamewaker_e_heat_wave_e1:GetRoshpitMasterAS()
	local caster = self:GetCaster()
	return self:GetStackCount()*FLAMEWAKER_E1_ATK_SPEED*caster:GetRuneValue("e", 1)
end

function modifier_flamewaker_e_heat_wave_e1:GetTexture()
	return "flamewaker/flamewaker_rune_e_1"
end