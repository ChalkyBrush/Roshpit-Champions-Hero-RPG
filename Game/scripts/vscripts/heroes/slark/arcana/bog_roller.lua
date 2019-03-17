LinkLuaModifier("slipfinn_bog_roller_lua", "modifiers/slipfinn/slipfinn_bog_roller_lua", LUA_MODIFIER_MOTION_NONE)

function turn_toggle_on(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	caster:StartGesture(ACT_DOTA_SLARK_POUNCE)
	-- Timers:CreateTimer(0.03, function()
	-- 	StartAnimation(caster, {duration=0.45, activity=ACT_DOTA_SLARK_POUNCE, rate=1.1})
	-- end)
	EmitSoundOn("Slipfinn.BogRoller.Start", caster)
	local soundChance = RandomInt(1, 3)
	if soundChance < 3 then
		EmitSoundOn("Slipfinn.BogRoller.Start.VO", caster)
	end
	Timers:CreateTimer(0.5, function()
		if caster:HasModifier("modifier_slipfinn_bog_roller") then
			EndAnimation(caster)

			caster:AddNewModifier( caster, ability, "slipfinn_bog_roller_lua", {} )
			StartSoundEvent("Slipfinn.BogRoller.LP", caster)
			StartSoundEvent("Slipfinn.BogRoller.LP2", caster)
			Timers:CreateTimer(0.03, function()
				StartAnimation(caster, {duration=99999, activity=ACT_DOTA_RUN, rate=1})
			end)
		end
	end)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_bog_roller", {})
	CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", caster, 2)
	caster:SetRenderColor(10, 150, 255)
	ability.fv = caster:GetForwardVector()
	ability.fall_speed = 0
	Filters:CastSkillArguments(2, caster)
	ability.rollspeed = caster.speed
end

function turn_toggle_off(event)
	local caster = event.caster
	local ability = event.ability
end

function bog_roller_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_slipfinn_buttstomp") then
		return false
	end
	if caster:IsChanneling() then
		return false
	end
	if caster:HasModifier("modifier_bog_roller_collision") then
		caster:SetForwardVector(ability.collisionFV)
		if not caster:HasModifier("modifier_slipfinn_basic_jump") then
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.collisionJumpForce))
			ability.collisionJumpForce = ability.collisionJumpForce - 2.5
		else
			caster:RemoveModifierByName("modifier_bog_roller_collision")
		end
		local distance_from_ground = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		if distance_from_ground < 10 and ability.collisionJumpForce < 0 then
			caster:RemoveModifierByName("modifier_bog_roller_collision")
		end
	else
		ability.rollspeed = math.min(ability.rollspeed + 1, 25)
		local rollSpeed = ability.rollspeed
		caster.speed = rollSpeed
		if caster:HasModifier("modifier_slipfinn_basic_jump") then
			rollSpeed = 0
		end
		local new_fv = (caster:GetForwardVector() + ability.fv*0.16):Normalized()
		caster:SetForwardVector(new_fv)
		local fv = caster:GetForwardVector()
		local new_position = caster:GetAbsOrigin() + fv*rollSpeed 

		local obstruction = WallPhysics:FindNearestObstruction(new_position)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, new_position, caster)
		local groundClimb = false
		local ground_new_pos = GetGroundPosition(new_position, caster)
		if ground_new_pos.z - 100 > caster:GetAbsOrigin().z then
			blockUnit = true 
		elseif ground_new_pos.z - 2 > caster:GetAbsOrigin().z then
			groundClimb = true
		elseif ground_new_pos.z + 2 < caster:GetAbsOrigin().z then
			if caster:HasModifier("modifier_slipfinn_basic_jump") then
				ability.fall_speed = 3
			else
				ability.fall_speed = ability.fall_speed + 2.5
			end
			new_position = new_position - Vector(0,0,ability.fall_speed)
		else
			ability.fall_speed = 0
		end
		if groundClimb then
			new_position = ground_new_pos
		end
		if not blockUnit then
			caster:SetOrigin(new_position)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_bog_roller_collision", {duration = 1})
			EmitSoundOn("Slipfinn.BogRoller.Collision", caster)
			ability.collisionFV = fv*-1
			ability.collisionJumpForce = 30
		end
	end

end

function mist_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	increment_d_b_stacks(caster, 1, ability)
end


function bog_roller_start(event)
	local caster = event.caster
	EmitSoundOn("Hydroxis.Arcana.MistStart", caster)
end

function bog_roller_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetRenderColor(255, 255, 255)
	caster:RemoveModifierByName("slipfinn_bog_roller_lua")
	EmitSoundOn("Slipfinn.BogRoller.End", caster)
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_SLARK_POUNCE, rate=1})
	end)
	StopSoundEvent("Slipfinn.BogRoller.LP", caster)
	StopSoundEvent("Slipfinn.BogRoller.LP2", caster)
end

function bog_roller_active_think(event)
	local caster = event.caster
	local ability = event.ability
end

function bog_roller_death(event)
	local caster = event.caster
	local ability = event.ability
	print(" THIS SHIZ?")
	Timers:CreateTimer(0.03, function()
		caster:RemoveModifierByName("modifier_hydroxis_mist")
	end)
end