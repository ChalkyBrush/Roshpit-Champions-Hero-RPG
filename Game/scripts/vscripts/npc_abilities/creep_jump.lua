function begin_holy_blink(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsStunned() then
		return false
	end
	abilityLevel = ability:GetLevel()
	ability.forwardVector = caster:GetForwardVector()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
	caster.holy_lift_velocity = 30
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	if caster:GetUnitName() == "crawler" then
		local sound_table = {"meepo_meepo_anger_02", "meepo_meepo_anger_06", "meepo_meepo_anger_05", "meepo_meepo_anger_18"}
		EmitSoundOn(sound_table[RandomInt(1, 4)], caster)
	end
end

function lift_think(keys)
	
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_creep_jump_lift")
	local origin = caster:GetAbsOrigin()
	
	if not caster.holy_lift_velocity then
		caster.holy_lift_velocity = 30
	end
	local newPosition = origin+Vector(0,0,caster.holy_lift_velocity)+ability.forwardVector*30
	caster.holy_lift_velocity = math.max(caster.holy_lift_velocity - 5, 10)
	caster:SetAbsOrigin(newPosition)
	ability.blink_position = newPosition + ability.forwardVector*400*Vector(1,1,0)
	--if origin.z - groundPosition.z > -200 then
	--	caster:SetAbsOrigin(groundPosition)
	--end
end

function begin_drop(event)
	local caster = event.caster
	local ability = event.ability
	caster.holy_lift_velocty = 0
	--caster:SetOrigin(ability.blink_position)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_creep_jump_drop", nil)
end

function drop_think(keys)
	local ability = keys.ability
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_creep_jump_drop")
	local origin = caster:GetAbsOrigin()
	
	if not caster.holy_lift_velocity then
		caster.holy_lift_velocity = 0
	end
	local newPosition = origin+Vector(0,0,-caster.holy_lift_velocity)+ability.forwardVector*40
	caster.holy_lift_velocity = math.min(caster.holy_lift_velocity + 5, 40)
	caster:SetAbsOrigin(newPosition)
	--value = newPosition.z - GetGroundPosition(newPosition, caster).z
	--print(value)
	if newPosition.z - GetGroundPosition(newPosition, caster).z < -50 then
		caster:RemoveModifierByName("modifier_creep_jump_drop")
	end

end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	local newLoc = GetGroundPosition(location, caster)
	caster:SetOrigin(newLoc)
	--FindClearSpaceForUnit(caster, newLoc, true)
  	--Timers:CreateTimer(0.5,     function()
    --  caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    --end)
	caster.holy_slide_velocity = 75
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_creep_jump_slide", nil)
	
end

function slide_think(keys)
	local ability = keys.ability
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_creep_jump_slide")
	local origin = caster:GetAbsOrigin()
	
	if not caster.holy_slide_velocity then
		caster.holy_slide_velocity = 75
	end
	--print(caster.holy_slide_velocity)
	local newPosition = origin+ability.forwardVector*caster.holy_slide_velocity
	caster.holy_slide_velocity = math.max(caster.holy_slide_velocity - 9, 0)
	caster:SetAbsOrigin(newPosition)

end

function slide_end(keys)
	local caster = keys.caster
	local location = caster:GetAbsOrigin()
	local newLoc = GetGroundPosition(location, caster)
	caster:SetOrigin(newLoc)
	FindClearSpaceForUnit(caster, newLoc, true)
  	Timers:CreateTimer(0.5,     function()
      caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    end)
	
end