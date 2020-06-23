require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
warp_flare_base = class(base_ability)

modifier_solunia_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_e_passive", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_warp_flare = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_warp_flare", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_between_warp = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_between_warp", "heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

function warp_flare_base:GetManaCostBase(level)
    return 0
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

    
    ability:EndCooldown()
end

function warp_flare_base:GetMaxWarpDistance()
	return self:GetSpecialValueFor("cast_range")
end

function warp_flare_base:GetMaxWarpCount()
	return 3
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
		ability.startRotation = WallPhysics:vectorToAngle(caster:GetForwardVector())
		caster:AddNewModifier(caster, ability, "modifier_solunia_between_warp", {duration = between_warp_time})
	else
		self:EndWarpFlare()
	end

	caster:RemoveModifierByName("modifier_solunia_warp_flare")
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
end

-- PASSIVE

function modifier_solunia_e_passive:IsHidden()
	return true
end

-- MAIN MODIFIER

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
	local forwardSpeed = SOLUNIA_E_TRAVEL_SPEED
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