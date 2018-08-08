function dinath_dive_precast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	ability.target_point = point
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_dive_precast", {duration = 1})
	ability.fv = ((ability.target_point- caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.curveVector = WallPhysics:rotateVector(ability.fv, 2*math.pi/4)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_postflight_zheight", {duration = 30})
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="flying"})
	EmitSoundOn("Dinath.DivePre", caster)
	ability.d_c_level = caster:GetRuneValue("e", 4)
end


function begin_dinath_dive(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	ability.dashSpeed = 22
	caster:RemoveModifierByName("modifier_dinath_dive_precast")
	local totalFlyDistance = WallPhysics:GetDistance2d(ability.target_point, caster:GetAbsOrigin())
	local ticksToReachPoint = 0
	local testSpeed = 22
	local testDistanceMoved = 0
	while testDistanceMoved < totalFlyDistance do
		testSpeed = math.min(testSpeed + 1, 40)
		testDistanceMoved = testDistanceMoved + testSpeed
		ticksToReachPoint = ticksToReachPoint + 1
		-- print(testDistanceMoved)
	end
	ability.distanceChecker = math.max(90, totalFlyDistance/100)
	ability.straightVector = caster:GetAbsOrigin()
	local divingDuration = ticksToReachPoint*0.03
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_diving", {duration = divingDuration})
	ability.curveTicks = ticksToReachPoint*1.5
	EmitSoundOn("Dinath.DiveStart", caster)
	if totalFlyDistance > 600 then
		EmitSoundOn("Dinath.DiveVO", caster)
	else
		EmitSoundOn("Dinath.DiveVOLight", caster)
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf", caster, divingDuration)
	local a_c_level = caster:GetRuneValue("e", 1)
	if a_c_level > 0 then
		local buffDuration = Filters:GetAdjustedBuffDuration(caster, 7, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_dive_attackspeed", {duration = buffDuration})
		caster:SetModifierStackCount("modifier_dinath_dive_attackspeed", caster, a_c_level)
	end
	local c_c_level = caster:GetRuneValue("e", 3)
	if c_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_dive_attack_range", {duration = divingDuration})
		caster:SetModifierStackCount("modifier_dinath_dive_attack_range", caster, c_c_level)
	end
	Filters:CastSkillArguments(3, caster)
	if caster:HasModifier("modifier_drake_dive_freecast") then
		caster:RemoveModifierByName("modifier_drake_dive_freecast")
		ability:EndCooldown()
	end
end

function dinath_dive_precast_think(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.fv*10)
	local zStacks = math.min(caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster) + 10, 480)
	caster:SetModifierStackCount("modifier_dinath_postflight_zheight", caster, zStacks)
	if not ability:IsInAbilityPhase() then
		caster:RemoveModifierByName("modifier_dinath_dive_precast")
		caster:RemoveModifierByName("modifier_animation_translate")
	end
end

function dinath_diving_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.dashSpeed = math.min(ability.dashSpeed + 1, 40)
	local moveVelocity = ability.dashSpeed
	ability.curveVector = WallPhysics:rotateVector(ability.curveVector, 2*math.pi*-1/ability.curveTicks)
	local newPosition = caster:GetAbsOrigin()+ability.fv*moveVelocity+ability.curveVector*24

	local beforeWallPosition = ability.straightVector
	ability.straightVector = ability.straightVector  + ability.fv*moveVelocity

	local afterWallPosition = WallPhysics:WallSearch(beforeWallPosition, ability.straightVector+ability.fv*moveVelocity, caster)
	local maxHeight = 480
	if caster:HasModifier("modifier_dinath_glyph_2_1") then
		maxHeight = maxHeight + 35
	end
	local zStacks = math.min(caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster) + 8, maxHeight)
	caster:SetModifierStackCount("modifier_dinath_postflight_zheight", caster, zStacks)

	if afterWallPosition == (ability.straightVector + ability.fv*moveVelocity) then
		caster:SetAbsOrigin(newPosition)
	else
		print("HERE?")
		caster:RemoveModifierByName("modifier_dinath_diving")
		caster:SetAbsOrigin(newPosition-ability.fv*moveVelocity)
	end

	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.fv*moveVelocity-Vector(0,0,40))
	if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.target_point) < ability.distanceChecker then
		caster:RemoveModifierByName("modifier_dinath_diving")
	end
end

function dinath_dive_end(event)
	local caster = event.caster
	local ability = event.ability
	local flying_duration = caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster)*0.03 + 0.03
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_postflight_actual_flying", {duration = flying_duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_postdive_slide", {duration = 4})
	local height = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
	ability.dashSpeed = ability.dashSpeed/2
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	local c_c_level = caster:GetRuneValue("e", 3)
	if c_c_level > 0 then
		local rangeBuff = Filters:GetAdjustedBuffDuration(caster, 1, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_dive_attack_range", {duration = rangeBuff})
		caster:SetModifierStackCount("modifier_dinath_dive_attack_range", caster, c_c_level)
	end
end

function dragon_height_z_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_dinath_dive_precast") then
		return false
	end
	if caster:HasModifier("modifier_dinath_diving") then
		return false
	end
	local heightReduce = 1
	if caster:HasModifier("modifier_dinath_scorch_charge_flying") then
		heightReduce = 0
	end
	if caster:HasModifier("modifier_dinath_glyph_2_1") and caster:HasModifier("modifier_channel_start") then
		heightReduce = 0
	end
	local stacks = caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster) - heightReduce
	if stacks > 1 then
		caster:SetModifierStackCount("modifier_dinath_postflight_zheight", caster, stacks)
	else
		caster:RemoveModifierByName("modifier_dinath_postflight_actual_flying")
		caster:RemoveModifierByName("modifier_dinath_postflight_zheight")
		caster:RemoveModifierByName("modifier_animation_translate")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_ARCTIC_BURN_END, rate=1.0})
	end
	if caster:HasModifier("modifier_dinath_postflight_actual_flying") then
		local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*60
		local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
		if blockUnit then
			caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*50)
			WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
			caster:RemoveModifierByName("modifier_dinath_postflight_actual_flying")
		end
	end
	if caster:HasModifier("modifier_dinath_postdive_slide") then
		if ability.dashSpeed > 0 and caster:HasModifier("modifier_dinath_postflight_actual_flying") then
			ability.dashSpeed = ability.dashSpeed - 0.7
			local pushDirection = (ability.fv + caster:GetForwardVector())/2
			caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.dashSpeed*pushDirection+ability.curveVector*4)
		end
	end
	if ability.d_c_level > 0 then
		local threshold = 450 - ability.d_c_level*3
		if stacks >= threshold then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_dive_attack_immune", {})
		else
			caster:RemoveModifierByName("modifier_dinath_dive_attack_immune")
		end
	end
end

function dinath_charge_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_recently_respawned") then
		return false
	end
	if caster:IsAlive() then
		local b_c_level = caster:GetRuneValue("e", 2)
		local attack_damage_from_gear = caster:GetModifierStackCount("modifier_trinket_attack_damage", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_body_attack_damage", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_hand_attack_damage", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_helm_attack_damage", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_weapon_attack_damage", caster.InventoryUnit)
		local bonus_attack = attack_damage_from_gear*0.15*b_c_level
		if bonus_attack > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_b_c_attack_power", {})
			caster:SetModifierStackCount("modifier_dinath_b_c_attack_power", caster, bonus_attack)
		else
			caster:RemoveModifierByName("modifier_dinath_b_c_attack_power")
		end
	end
end