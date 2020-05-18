require('heroes/winter_wyvern/dinath_constants')
require('heroes/base_ability')

dinath_frost_wyrm = class(base_ability)

modifier_dinath_frost_wyrm_channel = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_dinath_frost_wyrm_channel", "heroes/winter_wyvern/arcana/dinath_frost_wyrm", LUA_MODIFIER_MOTION_NONE)

modifier_dinath_frost_wyrm_flying_to_cast_point = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_dinath_frost_wyrm_flying_to_cast_point", "heroes/winter_wyvern/arcana/dinath_frost_wyrm", LUA_MODIFIER_MOTION_NONE)

modifier_dinath_frost_wyrm_bomb_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_dinath_frost_wyrm_bomb_thinker", "heroes/winter_wyvern/arcana/dinath_frost_wyrm", LUA_MODIFIER_MOTION_NONE)

modifier_dinath_frost_wyrm_turn_rate_while_firing = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_dinath_frost_wyrm_turn_rate_while_firing", "heroes/winter_wyvern/arcana/dinath_frost_wyrm", LUA_MODIFIER_MOTION_NONE)

modifier_dinath_frost_wyrm_slow = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_dinath_frost_wyrm_slow", "heroes/winter_wyvern/arcana/dinath_frost_wyrm", LUA_MODIFIER_MOTION_NONE)

function dinath_frost_wyrm:GetManaCostBase(level)
    return 0
end

function dinath_frost_wyrm:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function dinath_frost_wyrm:GetAbilitySlot()
    return DOTA_R_SLOT
end

function dinath_frost_wyrm:GetCastPoint()
    return 0
end

function dinath_frost_wyrm:GetCooldownBase(level)
	local caster = self:GetCaster()
	if IsServer() then
    	return math.max(DINATH_ARCANA2_COOLDOWN + caster:GetRuneValue("r", 4)*DINATH_ARCANA2_RUNE_R4_COOLDOWN_REDUCTION, 0)
    else
    	return DINATH_ARCANA2_COOLDOWN
    end
end

function dinath_frost_wyrm:GetCastRange()
	local caster = self:GetCaster()
	if IsServer() then
    	return DINATH_ARCANA2_CAST_RANGE + caster:GetRuneValue("r", 1)*DINATH_ARCANA2_RUNE_R1_CAST_RANGE
    else
    	return DINATH_ARCANA2_CAST_RANGE
    end
end

function dinath_frost_wyrm:GetMaxProjectileRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("projectile_range") + caster:GetRuneValue("r", 1)*DINATH_ARCANA2_RUNE_R1_PROJECTILE_RANGE
end

function dinath_frost_wyrm:GetTexture()
    return "arkimus/dinath_frost_wyrm"
end

function dinath_frost_wyrm:GetChannelTimeBase()
	local caster = self:GetCaster()
	if IsServer() then
    	return math.max(DINATH_ARCANA2_CHANNEL_TIME + caster:GetRuneValue("r", 4)*DINATH_ARCANA2_RUNE_R4_CHANNEL_TIME_REDUCTION, 0)
    else
    	return DINATH_ARCANA2_CHANNEL_TIME
    end
end

function dinath_frost_wyrm:GetCastAnimation()
    return ACT_DOTA_TELEPORT
end

function dinath_frost_wyrm:OnSpellStartBase()
    local hero = self:GetCaster()
	local ability = self
    hero:AddNewModifier(hero, ability, "modifier_dinath_frost_wyrm_channel", {})
	if not ability.dragonVOlock then
		ability.dragonVOlock = true
		EmitSoundOn("Dinath.HyperBeam.StartVO", hero)
		Timers:CreateTimer(1, function()
			ability.dragonVOlock = false
		end)
	end
    StartSoundEvent("Dinath.FrostyWyrm.ChannelLP", hero)
end

function dinath_frost_wyrm:OnChannelFinish(interrupted)
    if IsServer() then
        local hero = self:GetCaster()
        StopSoundEvent("Dinath.FrostyWyrm.ChannelLP", hero)
        hero:RemoveModifierByName("modifier_dinath_frost_wyrm_channel")
        if interrupted then
            
        else
            local ability = self
		    local caster = self:GetCaster()
			local point_of_cast = ability:GetPointOfCast()
			local fv = ability:GetDirectionVector()

			local distance = self:GetMaxProjectileRange()

			local endPoint = ability:GetTerminalPosition()
			local distance_of_cast = WallPhysics:GetDistance2d(point_of_cast, endPoint)
			if distance_of_cast > distance then
				endPoint = point_of_cast + fv*distance
			end
			ability.bomb_point = endPoint
			ability.final_fv = fv*Vector(1,1,0)
			if ability.final_fv:Length2D() < 1 then
				ability.final_fv = RandomVector(1)
			end

			local zStacks = DINATH_MAX_FLY_HEIGHT
			local e_ability = caster:GetAbilityByIndex(DOTA_E_SLOT)
			e_ability:ApplyDataDrivenModifier(hero, hero, "modifier_dinath_postflight_zheight", {})
		
			if not e_ability.e_4_level then
				e_ability.e_4_level = caster:GetRuneValue("e", 4)
			end
			EmitSoundOn("Dinath.DiveStart", hero)

			self:SetupMotionToCastPoint(point_of_cast, fv, endPoint)
            Filters:CastSkillArguments(BASE_ABILITY_R, hero)
        end
    end
end

function dinath_frost_wyrm:SetupMotionToCastPoint(point_of_cast, fv, endPoint)
	local ability = self
	local hero = self:GetCaster()
	local startPos = hero:GetAbsOrigin()
	local time_to_reach_cast_point = 0.5
	local direction2d = ((point_of_cast - startPos)*Vector(1,1,0)):Normalized()
	local distance_to_end_point = WallPhysics:GetDistance2d(startPos, point_of_cast)
	local movespeed = (distance_to_end_point/time_to_reach_cast_point)*0.03

	local heightDifferential = DINATH_MAX_FLY_HEIGHT - hero:GetModifierStackCount("modifier_dinath_postflight_zheight", hero)
	ability.movespeed = movespeed
	ability.height_per_tick = (heightDifferential/time_to_reach_cast_point)*0.03
	ability.direction2d = direction2d
	hero:AddNewModifier(hero, ability, "modifier_dinath_frost_wyrm_flying_to_cast_point", {duration = time_to_reach_cast_point})
end

function dinath_frost_wyrm:FrostWyrmProjectile(offset)
	local caster = self:GetCaster()
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.6})
	EmitSoundOn("Dinath.FireBomb.Launch", caster)
	local ability = self
	local flightStacks = caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster)

	local bomb_position = ((caster:GetAbsOrigin() + caster:GetForwardVector() * 120) * Vector(1, 1, 0)) + Vector(0, 0, caster:GetAbsOrigin().z + 70 + flightStacks)
	if not offset then
		offset = Vector(0,0)
	end
	local distance2d = math.max(WallPhysics:GetDistance2d(bomb_position, ability.bomb_point+offset), 100)
	local bomb = CreateUnitByName("npc_dummy_unit", bomb_position, false, nil, nil, caster:GetTeamNumber())
	bomb:SetAbsOrigin(bomb_position)

	
	local speed_2d = distance2d*2

	local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/arctic_burn_bomb_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, bomb:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(10, 10, 10))

	bomb.pfx = pfx
	bomb:SetDayTimeVisionRange(400)
	bomb:SetNightTimeVisionRange(400)
	bomb:AddNewModifier(caster, ability, "modifier_dinath_frost_wyrm_bomb_thinker", {duration = 1})
	bomb.speed_2d = speed_2d
	local bombFV = (((ability.bomb_point + offset) - bomb_position)*Vector(1,1,0)):Normalized()

	
	local timeToReachEnd2d = distance2d/speed_2d
	local zSpeed = math.max((bomb_position.z - ability.bomb_point.z)/timeToReachEnd2d, 10)

	bomb.moveFV = (bombFV*speed_2d - Vector(0,0,zSpeed))*0.033
	bomb:FindAbilityByName("dummy_unit"):SetLevel(1)

end

-- BOMB THINKER

function modifier_dinath_frost_wyrm_bomb_thinker:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_dinath_frost_wyrm_bomb_thinker:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local bomb = self:GetParent()
	bomb:SetAbsOrigin(bomb:GetAbsOrigin() + bomb.moveFV)
	ParticleManager:SetParticleControl(bomb.pfx, 0, bomb:GetAbsOrigin())

	if bomb:GetDistanceFromGround() < 5 then
		local hero = self:GetAbility():GetCaster()
		local ability = self:GetAbility()
		bomb:RemoveModifierByName("modifier_dinath_frost_wyrm_bomb_thinker")
		ParticleManager:DestroyParticle(bomb.pfx, false)
		AddFOWViewer(hero:GetTeamNumber(), bomb:GetAbsOrigin(), 400, 2, false)
		ability:BombExplosion(bomb:GetAbsOrigin())
		Timers:CreateTimer(0.03, function()
			UTIL_Remove(bomb)
		end)
	end
end

function dinath_frost_wyrm:BombExplosion(position)
	local caster = self:GetCaster()
	local ability = self
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	local radius = ability:GetSpecialValueFor("explode_radius") + caster:GetRuneValue("r", 2)*DINATH_ARCANA2_RUNE_R2_RADIUS_INCREASE
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, radius/2))
	ParticleManager:SetParticleControl(particle1, 3, Vector(radius, radius, radius))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOn("Dinath.FrostyWyrm.BombExplode", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*((ability:GetSpecialValueFor("damage_mult") + caster:GetRuneValue("r", 2)*DINATH_ARCANA2_RUNE_R2_DAMAGE_INCREASE)/100)
	local duration = ability:GetSpecialValueFor("slow_duration")
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_DRAGON, RPC_ELEMENT_ICE)
			enemy:AddNewModifier(caster, ability, "modifier_dinath_frost_wyrm_slow", {duration = duration})
		end
	end
end

-- CHANNEL EFFECT

function modifier_dinath_frost_wyrm_channel:IsHidden()
	return true
end

function modifier_dinath_frost_wyrm_channel:GetEffectName()
	return "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water_channel.vpcf"
end

function modifier_dinath_frost_wyrm_channel:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_dinath_frost_wyrm_channel:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
    return funcs
end

function modifier_dinath_frost_wyrm_channel:GetOverrideAnimation()
	return ACT_DOTA_TELEPORT
end

-- FLYING TO CAST POINT EFFECT

function modifier_dinath_frost_wyrm_flying_to_cast_point:IsHidden()
	return true
end

function modifier_dinath_frost_wyrm_flying_to_cast_point:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_dinath_frost_wyrm_flying_to_cast_point:GetEffectName()
	return "particles/roshpit/dinath/dive_rush.vpcf"
end

function modifier_dinath_frost_wyrm_flying_to_cast_point:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_dinath_frost_wyrm_flying_to_cast_point:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local hero = self:GetParent()
	print(ability.movespeed)
	print(ability.direction2d)
	local newPos = hero:GetAbsOrigin() + ability.direction2d*ability.movespeed
	local obstruction = WallPhysics:FindNearestObstruction(newPos)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos+ability.direction2d*10, hero)
	if not blockUnit then
		hero:SetAbsOrigin(newPos)
	end
	local current_stacks = hero:GetModifierStackCount("modifier_dinath_postflight_zheight", hero)
	hero:SetModifierStackCount("modifier_dinath_postflight_zheight", hero, current_stacks + ability.height_per_tick)
end

function modifier_dinath_frost_wyrm_flying_to_cast_point:OnRemoved()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local hero = self:GetParent()
	hero:FaceTowards(ability.bomb_point)
	-- hero:MoveToPosition(hero:GetAbsOrigin() + ability.final_fv*20)
	EmitSoundOn("Dinath.DiveVOLight", hero)
	FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
	-- SHOOT FIREBALLS
	-- 
	local count = ability:GetSpecialValueFor("projectile_count") + Runes:Procs(hero:GetRuneValue("r", 3), DINATH_ARCANA2_RUNE_R3_MULTI_CHANCE, 1)

	-- Timers:CreateTimer(0.03, function()
	-- 	hero:AddNewModifier(hero, ability, "modifier_dinath_frost_wyrm_turn_rate_while_firing", {duration = count*0.15})
	-- end)
	for i = 0, count-1, 1 do
		Timers:CreateTimer(i*0.15, function()
			local offSet = Vector(1,1)
			if i > 0 then
				offset = RandomVector(RandomInt(40, 160))
			end
			ability:FrostWyrmProjectile(offset)
		end)
	end
end

-- TURNRATE

function modifier_dinath_frost_wyrm_turn_rate_while_firing:IsHidden()
	return true
end

function modifier_dinath_frost_wyrm_turn_rate_while_firing:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
    }
    return funcs
end

function modifier_dinath_frost_wyrm_turn_rate_while_firing:GetModifierTurnRate_Percentage()
	return -1000
end

-- SLOW MODIFIER

function modifier_dinath_frost_wyrm_slow:IsDebuff()
	return true
end

function modifier_dinath_frost_wyrm_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_dinath_frost_wyrm_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_dinath_frost_wyrm_slow:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_dinath_frost_wyrm_slow:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("ms_slow")
end

function modifier_dinath_frost_wyrm_slow:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("as_slow")
end