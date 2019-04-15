if WallPhysics == nil then
  WallPhysics = class({})
end

-- knockup formula: sin((current_time - time_knock_up_started) / total_knock_up_time * PI) * max_height

function WallPhysics:FindNearestObstruction(point)
	if GameState:IsWorld1() then
		local eventBlocker = WallPhysics:FindEventObstructions(point)
		if not eventBlocker then
			return Entities:FindByNameNearest("wallObstruction", point, 1400)
		else
			return eventBlocker
		end
	else
		local obstruction = Entities:FindByClassnameNearest("point_simple_obstruction", point, 1400)
		if obstruction then
			-- print(obstruction:GetAbsOrigin())
			if obstruction:GetAbsOrigin().z < point.z - 300 then
				local searchPos = Vector(point.x, point.y, GetGroundHeight(point, Events.GameMaster))
				local obstruction2 = Entities:FindByClassnameNearest("point_simple_obstruction", searchPos, 500)
				if obstruction2 then
					obstruction = obstruction2
				end
			end
		end

		return obstruction
	end
end

function WallPhysics:FindEventObstructions(point)
	point = point*Vector(1,1,0)
	if Dungeons.blocker1 then
		local blockerPos = Dungeons.blocker1:GetAbsOrigin()*Vector(1,1,0)
		if (point - blockerPos):Length2D() < 90 then			
			return Dungeons.blocker1
		end
	end
	if Dungeons.blocker2 then
		local blockerPos = Dungeons.blocker2:GetAbsOrigin()*Vector(1,1,0)
		if (point - blockerPos):Length2D() < 90 then			
			return Dungeons.blocker2
		end
	end
	if Dungeons.blocker3 then
		local blockerPos = Dungeons.blocker3:GetAbsOrigin()*Vector(1,1,0)
		if (point - blockerPos):Length2D() < 90 then			
			return Dungeons.blocker3
		end
	end
	if Dungeons.blocker4 then
		local blockerPos = Dungeons.blocker4:GetAbsOrigin()*Vector(1,1,0)
		if (point - blockerPos):Length2D() < 90 then			
			return Dungeons.blocker4
		end
	end
	if Dungeons.blocker5 then
		local blockerPos = Dungeons.blocker5:GetAbsOrigin()*Vector(1,1,0)
		if (point - blockerPos):Length2D() < 90 then			
			return Dungeons.blocker5
		end
	end

	return false
end

function WallPhysics:DoesTableHaveValue(table, val)
	for index, value in ipairs(table) do
		if value == val then
			return true
		end
	end
	return false
end

function WallPhysics:vectorToAngle(vector)
	return math.atan2(vector.y, vector.x)*180/math.pi
end

function WallPhysics:angleToVector(angle)
	local x = math.cos(math.rad(angle))
	local y = math.sin(math.rad(angle))
	return Vector(x,y)
end

function WallPhysics:ShouldBlockUnit(obstruction, point, unit, isDistanceSearch)
	if unit:HasModifier("modifier_mobility_blocked") then
		return true
	end
	if Dungeons.phoenixCollision then
		local shouldBlock = Dungeons:PhoenixCollisionCalc(unit, point, isDistanceSearch)
		if shouldBlock then
			return true
		end
	end
	if obstruction then
		local distance = WallPhysics:GetDistance(obstruction:GetAbsOrigin()*Vector(1,1,0), point*Vector(1,1,0))
		if distance > 120 then
			return false
		else
			return true
		end
	else
		return false
	end
end

function WallPhysics:GetDistance(a,b)
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(x*x+y*y+z*z)
end

function WallPhysics:GetDistance2d(a,b)
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(x*x+y*y)
end

function WallPhysics:WallSearch(startPoint, endPoint, unit)
	startPointNoZ = startPoint*Vector(1,1,0)+Vector(0,0,GetGroundHeight(startPoint, unit))
	endPointNoZ = endPoint*Vector(1,1,0)+Vector(0,0,GetGroundHeight(endPoint, unit))
	local distance = WallPhysics:GetDistance(startPointNoZ, endPointNoZ)
	local normal = (endPoint-startPoint):Normalized()*Vector(1,1,0)
	local checkCount = distance/75
	for i = 1, checkCount+1, 1 do
		local obstruction = WallPhysics:FindNearestObstruction(startPointNoZ+normal*i*75)
		local block = WallPhysics:ShouldBlockUnit(obstruction, startPointNoZ+normal*i*75, unit, true) 
		if block then
			print("BLOCKED!!")
			return startPoint+normal*(i-1)*75-normal*50
		end
	end
	return endPoint
end

function WallPhysics:SetAllWallObstructions()
	local walls = Entities:FindAllByName("wallObstruction")
	for i = 1, #walls, 1 do
		walls[i]:SetAbsOrigin(walls[i]:GetAbsOrigin()*Vector(1,1,0))
	end
end

function WallPhysics:round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function WallPhysics:ShouldBlockUnitTwo(point)
	local walls = Entities:FindByNameNearest("wallObstruction", point, 90)
	if walls then
		if #walls > 0 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function WallPhysics:rotateVector(vector, radians)
   XX = vector.x
   YY = vector.y
   
   Xprime = math.cos(radians)*XX -math.sin(radians)*YY
   Yprime = math.sin(radians)*XX +math.cos(radians)*YY

   vectorX = Vector(1,0,0)*Xprime
   vectorY = Vector(0,1,0)*Yprime
   rotatedVector = vectorX + vectorY
   return rotatedVector
   
end

function WallPhysics:Jump(unit, forwardVector, propulsion, liftForce, liftDuration, gravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
	if unit.jumpLock then
		return false
	end
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			if IsValidEntity(unit) then
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)
				unit:SetOrigin(newPosition)
			end
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03*liftDuration+0.03, function()
		Timers:CreateTimer(0.03*fallLoop, function()
			if IsValidEntity(unit) then
				fallLoop = fallLoop + 1
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity)
				unit:SetOrigin(newPosition)
				if newPosition.z - GetGroundPosition(newPosition, unit).z < 10 then
					unit:RemoveModifierByName("modifier_jumping")
					FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
				else
					return 0.03
				end
			end
		end)
	end)
end

function WallPhysics:JumpWithBlocking(unit, forwardVector, propulsion, liftForce, liftDuration, gravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			if IsValidEntity(unit) then
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)

				local obstruction = WallPhysics:FindNearestObstruction(newPosition)
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
				if blockUnit then
					newPosition = newPosition - forwardVector*propulsion
				end
				unit:SetOrigin(newPosition)
			end
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03*liftDuration+0.03, function()
		Timers:CreateTimer(0.03*fallLoop, function()
			if IsValidEntity(unit) then
				fallLoop = fallLoop + 1
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity)

				local obstruction = WallPhysics:FindNearestObstruction(newPosition)
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
				if blockUnit then
					newPosition = newPosition - forwardVector*propulsion
				end

				unit:SetOrigin(newPosition)
				if newPosition.z - GetGroundPosition(newPosition, unit).z < 10 then
					unit:RemoveModifierByName("modifier_jumping")
					FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
				else
					return 0.03
				end
			end
		end)
	end)
end

function WallPhysics:JumpFixedDistanceWithBlocking(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
	local liftDuration = distance/propulsion/2
	local endLocation = unit:GetAbsOrigin()+forwardVector*distance
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			local currentPosition = unit:GetAbsOrigin()

			local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)

		    local obstruction = WallPhysics:FindNearestObstruction(newPosition)
		    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
		    if not blockUnit then
		        unit:SetOrigin(newPosition)
		    else 
		    	print("SHOULD BE BLOCKING?")
		    	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_mobility_blocked", {duration = 1.5})
		        unit:SetOrigin(newPosition-forwardVector*propulsion)
		    end
		    CustomAbilities:HeroicLeapThink(unit)
			
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03*liftDuration+0.03, function()
		Timers:CreateTimer(0.03*fallLoop, function()
			fallLoop = fallLoop + 1
			local currentPosition = unit:GetAbsOrigin()
			local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity*fallGravity)

		    local obstruction = WallPhysics:FindNearestObstruction(newPosition)
		    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
		    if not blockUnit then
		        unit:SetOrigin(newPosition)
		    else 
		    	gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_mobility_blocked", {duration = 1.5})
		        unit:SetOrigin(newPosition-forwardVector*propulsion)
		    end
		    CustomAbilities:HeroicLeapThink(unit)
			if fallLoop > liftDuration then
				unit:RemoveModifierByName("modifier_jumping")
				FindClearSpaceForUnit(unit, currentPosition, false)
				WallPhysics:UnitLand(unit)
			else
				if newPosition.x <= endLocation.x + 20 and newPosition.x >= endLocation.x-20 and newPosition.y <= endLocation.y+20 and newPosition.y >= endLocation.y-20 then
					unit:RemoveModifierByName("modifier_jumping")
					FindClearSpaceForUnit(unit, currentPosition, false)
					WallPhysics:UnitLand(unit)
				else
					return 0.03
				end
			end
		end)
	end)
end

function WallPhysics:JumpFixedDistanceNoBlocking(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_jumping"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
	local liftDuration = distance/propulsion/2
	local endLocation = unit:GetAbsOrigin()+forwardVector*distance
	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			local currentPosition = unit:GetAbsOrigin()
			local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)
		    unit:SetOrigin(newPosition)
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03*liftDuration+0.03, function()
		Timers:CreateTimer(0.03*fallLoop, function()
			fallLoop = fallLoop + 1
			local currentPosition = unit:GetAbsOrigin()
			local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity*fallGravity)

		    local obstruction = WallPhysics:FindNearestObstruction(newPosition)
		    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
		    unit:SetOrigin(newPosition)
			if fallLoop > liftDuration then
				unit:RemoveModifierByName("modifier_jumping")
				FindClearSpaceForUnit(unit, currentPosition, false)
				WallPhysics:UnitLand(unit)
			else
				if newPosition.x <= endLocation.x + 20 and newPosition.x >= endLocation.x-20 and newPosition.y <= endLocation.y+20 and newPosition.y >= endLocation.y-20 then
					unit:RemoveModifierByName("modifier_jumping")
					FindClearSpaceForUnit(unit, currentPosition, false)
					WallPhysics:UnitLand(unit)
				else
					return 0.03
				end
			end
		end)
	end)
end

function WallPhysics:UnitLand(unit)
	local caster = unit
	if caster.jumpEnd then
		if caster.jumpEnd == "stop_flail" then
			caster.jumpEnd = nil
			caster:RemoveModifierByName("modifier_wind_temple_flailing")
		end
		if caster.jumpEnd == "catapult" then
			EmitSoundOn("Hero_Gyrocopter.CallDown.Damage", caster)
			particleName = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
			local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin() )
			Timers:CreateTimer(5, 
				function()
				ParticleManager:DestroyParticle( particle1, false )
			end)
			caster:SetModel("models/development/invisiblebox.vmdl")
			caster:SetOriginalModel("models/development/invisiblebox.vmdl")			
			Timers:CreateTimer(1, function()
				UTIL_Remove(caster)
			end)
			local casterPos = caster:GetAbsOrigin()
			local modifierKnockback =
			{
				center_x = casterPos.x,
				center_y = casterPos.y,
				center_z = casterPos.z,
				duration = 0.4,
				knockback_duration = 0.4,
				knockback_distance = 280,
				knockback_height = 220
			}
      
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterPos, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
					ApplyDamage({ victim = enemy, attacker = caster, damage = 500, damage_type = DAMAGE_TYPE_MAGICAL })
				end
			end 
		end
		if caster.jumpEnd == "hermit" then
			EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", caster)
			local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
			local position = caster:GetAbsOrigin()
			local particleVector = position

			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, particleVector )
			ParticleManager:SetParticleControl( pfx, 1, particleVector )
			ParticleManager:SetParticleControl( pfx, 2, particleVector )
			Timers:CreateTimer(1, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end)  
			ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = 3000, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR })
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.4})
				end
			end
		end
		if caster.jumpEnd == "cloudburst" then
			EmitSoundOn("Tanari.StaffGuardianLand", caster)
			local position = caster:GetAbsOrigin()
			local particleVector = position
			StartAnimation(caster, {duration=.8, activity=ACT_DOTA_TELEPORT_END, rate=.9}) 
			local particleName =  "particles/units/heroes/hero_elder_titan/monk_cloud_burst.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, particleVector )
			ParticleManager:SetParticleControl( pfx, 1, particleVector )
			ParticleManager:SetParticleControl( pfx, 2, particleVector )
			Timers:CreateTimer(1, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end)  
			ScreenShake(position, 200, 0.8, 1, 9000, 0, true)
			local damage = Events:GetDifficultyScaledDamage(1000, 10000, 100000)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.8})
				end
			end
			Timers:CreateTimer(2, function()
				EmitSoundOn("elder_titan_elder_kill_"..RandomInt(17,19), caster)
			end)
		end
		if caster.jumpEnd == "ruins_boss" then
			EmitSoundOn("Hero_OgreMagi.Fireblast.Target", caster)
			local position = caster:GetAbsOrigin()
			local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
	      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      	local origin = caster:GetAbsOrigin()
	      	ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,200) )
	      	ParticleManager:SetParticleControl( particle1, 1, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 2, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 3, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 4, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 5, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 6, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 7, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 8, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 9, Vector(300,300,300) )
			Timers:CreateTimer(1, function() 
			  ParticleManager:DestroyParticle( particle1, false )
			end)  

			ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
			local damage = Events:GetAdjustedAbilityDamage(1400, 10000, 50000)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
					enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.2})
				end
			end
			caster.jumpsRemaining = caster.jumpsRemaining - 1
			if caster.jumpsRemaining > 0 then
				local targets = Dungeons:GetTargetTable()
				local target = targets[RandomInt(1, #targets)]
				local jumpVector = (target:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized()
				WallPhysics:Jump(caster, jumpVector, 30, 60, 1.5, 1.5)
			else
				caster:RemoveModifierByName("modifier_ruins_jumping")
			end
		elseif caster.jumpEnd == "doom_boss" then
			EmitSoundOn("Hero_OgreMagi.Fireblast.Target", caster)
			local position = caster:GetAbsOrigin()
			local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
	      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      	local origin = caster:GetAbsOrigin()
	      	ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,200) )
	      	ParticleManager:SetParticleControl( particle1, 1, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 2, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 3, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 4, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 5, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 6, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 7, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 8, Vector(300,300,300) )
	      	ParticleManager:SetParticleControl( particle1, 9, Vector(300,300,300) )
			Timers:CreateTimer(1, function() 
			  ParticleManager:DestroyParticle( particle1, false )
			end)  

			ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
			-- local damage = Events:GetAdjustedAbilityDamage(3400, 30000, 80000)
			-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			-- if #enemies > 0 then
			-- 	for _,enemy in pairs(enemies) do
			-- 		ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			-- 		enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.5})
			-- 	end
			-- end	
		elseif caster.jumpEnd == "lava_legion" then
			StartAnimation(caster, {duration=.8, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=.8}) 
			caster.jumpEnd = false
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			EmitSoundOn("Tanari.LegionLand", caster)
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		elseif caster.jumpEnd == "basic_dust" then
			caster.jumpEnd = false
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		elseif caster.jumpEnd == "basic_land" then
			caster.jumpEnd = false
			EmitSoundOn("Tanari.Bomb.Land", caster)
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		elseif caster.jumpEnd == "kraken_king" then
			local position = caster:GetAbsOrigin()
			ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
			local ravage = caster:FindAbilityByName("tanari_kraken_ravage")
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = ravage:entindex(),
			 	}					 
			ExecuteOrderFromTable(newOrder)
		elseif caster.jumpEnd == "sunder" then
			caster.jumpEnd = false
			local ability = caster:FindAbilityByName("sunder")
			local damage = ability:GetSpecialValueFor("main_damage")
			local q_3_level = caster:GetRuneValue("q", 3)
			local damageAmp = 0.5 + q_3_level*0.1
			CustomAbilities:AxeSunder(caster, ability, damage, damageAmp, "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf")		
		elseif caster.flamewaker_d_b_target then
			print("block1")
			if IsValidEntity(caster.flamewaker_d_b_target) then
				if caster.flamewaker_d_b_target:IsAlive() then
					print("blockMAIN")
					EmitSoundOn("Flamewaker.SpecialCrit", caster.flamewaker_d_b_target)
					local target = caster.flamewaker_d_b_target

					local particleName =  "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/flamewaker_crit.vpcf"
					local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		     	 	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin()+Vector(0,0,40) )
					local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		     	 	ParticleManager:SetParticleControl( pfx2, 0, target:GetAbsOrigin()+Vector(0,0,10) )
					Timers:CreateTimer(0.4, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					  ParticleManager:DestroyParticle( pfx2, false )
					end) 	

					Timers:CreateTimer(0.06, function()
						EmitSoundOn("Flamewaker.SpecialCrit", target)
						caster:PerformAttack(target, true, true, false, true, false)
						local damageApprox = math.ceil(OverflowProtectedGetAverageTrueAttackDamage(caster))
						PopupDamage(target, damageApprox)
						Timers:CreateTimer(0.03, function()
							caster:RemoveModifierByName("modifier_flamewaker_rune_w_4")
						end)
					end)
				end
			end

			caster.flamewaker_d_b_target = false
		elseif caster.warlord_ambush_target then
			CustomAbilities:Warlord_Ambush(caster, caster.warlord_ambush_target)
			caster.warlord_ambush_target = false
		elseif caster.flamewaker_3_1 then
			CustomAbilities:Flamewaker_3_1_glyph(caster)	
		elseif caster.jumpEnd == "red_raven" then
			caster.jumpEnd = false
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(300, 300, 300) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		elseif caster.jumpEnd == "pfx" then
			caster.jumpEnd = false
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( caster.jumpPFX, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(300, 300, 300) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)	
		elseif caster.jumpEnd == "crab_land" then
			caster.jumpEnd = false
			local position = caster:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/league_teleport_2014/teleport_end_dust_league.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, position )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)				
			EmitSoundOn("Winterblight.Crab.Land", caster)
		else
			CustomAbilities:JumpEnd(caster)
		end
	end
end

function WallPhysics:GetRandomItemFromTable(table)
	local randomElement = table[RandomInt(1,#table)]
	return randomElement
end

function WallPhysics:IsWithinRegion(unit, position, range)
	local casterOrigin = unit:GetAbsOrigin()
	if casterOrigin.x > position.x-range and casterOrigin.y > position.y-range and casterOrigin.x < position.x+range and casterOrigin.y < position.y+range then
		return true
	else
		return false
	end
end

function WallPhysics:IsWithinRegionA(casterOrigin, bottomleft, topright)
	if casterOrigin.x > bottomleft.x and casterOrigin.y > bottomleft.y and casterOrigin.x < topright.x and casterOrigin.y < topright.y then
		return true
	else
		return false
	end
end

function WallPhysics:MoveWithBlocking(startPosition, newPosition, caster)
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
end

function WallPhysics:ShuffleTable(tbl)
  size = #tbl
  for i = size, 1, -1 do
    local rand = math.random(size)
    tbl[i], tbl[rand] = tbl[rand], tbl[i]
  end
  return tbl
end

function WallPhysics:normalized_2d_vector(startPos, endPos)
	local vec = ((endPos - startPos)*Vector(1,1,0)):Normalized()
	return vec
end

function WallPhysics:table_unique(tt)
	local newtable
	newtable = {}
	for ii,xx in ipairs(tt) do
		if(WallPhysics:table_count(newtable, xx) == 0) then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end

function WallPhysics:table_count(tt, item)
	local count
	count = 0
	for ii,xx in pairs(tt) do
		if item == xx then count = count + 1 end
	end
	return count
end

function WallPhysics:ClearSpaceForUnit(unit, position)
	if GridNav:IsTraversable(unit:GetAbsOrigin()) then
		FindClearSpaceForUnit(unit, position, false)
	else
		if unit.safePos then
			FindClearSpaceForUnit(unit, unit.safePos, false)
		end
	end
end

function WallPhysics:ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function WallPhysics:RandomPointInSquare(vec1, vec2)
	local point = vec1 + Vector(RandomInt(0, vec2.x - vec1.x), RandomInt(0, vec2.y - vec1.y))
	return point
end

function WallPhysics:RandomString(length)
local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

if not length or length <= 0 then return '' end
return WallPhysics:RandomString(length - 1) .. charset[RandomInt(1, #charset)]

end