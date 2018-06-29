function winterblight_unit_die(event)
	local unit = event.unit
	if unit.deathCode == 1 then
		if not Winterblight.TitansSlain then
			Winterblight.TitansSlain = 0
		end
		Winterblight.TitansSlain = Winterblight.TitansSlain + 1
		if Winterblight.TitansSlain == 3 then
			Winterblight:StartOrbSequence()
		end
	elseif unit.deathCode == 2 then
		Winterblight:AzaleaMathUnitDie(unit)
	end
	if not Winterblight.WinterblightUnitsSlain then
		Winterblight.WinterblightUnitsSlain = 0
	end
	Winterblight.WinterblightUnitsSlain = Winterblight.WinterblightUnitsSlain + 1
	if Winterblight.WinterblightUnitsSlain == 100 then
		Winterblight.AltarDisabled = true
		CustomGameEventManager:Send_ServerToAllClients("close_altar_of_ice", {} )
	end
end

function snowball_kid_preattack(event)
	local caster = event.caster
	local ability = event.ability
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 300, 3, false)
end

function village_snowball_hit(event)
	local target = event.target
	local caster = event.caster
	EmitSoundOn("Villager.Laugh", caster)
	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_FLAIL, rate=1.8})
end

function ice_end(event)
	local target = event.target
	target.icePrevPosition = nil
	Timers:CreateTimer(0.03, function()
		if IsValidEntity(target) then
			if target:GetAbsOrigin().z - GetGroundHeight(target.safePos, target) < 5 then
				FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
			end
		end
	end)
end

function ice_think(event)
	local target = event.target
	local caster = target
	local ability = event.ability
	if caster:HasModifier("modifier_winterblight_puck_motion") then
		return false
	end
	if Filters:IsTouchingGround(target) then
		local slip_speed = 3
		local turn_rate = 1
		if not caster.icePrevPosition then
			caster.icePrevPosition = caster:GetAbsOrigin()
			caster.iceDirection = caster:GetForwardVector()
			caster.iceSpeed = 0
			caster.ice_speed_slip_max = 9
			caster.iceInterval =0
			return false
		end
		if Filters:HasMovementModifier(caster) then
			return false
		end

		local onGround = true
		local differential = (caster:GetAbsOrigin()-caster.icePrevPosition)*Vector(1,1,0)
		local direction = differential:Normalized()
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.icePrevPosition)
		local speedGain = distance*0.02*slip_speed
		caster.differential = differential
		if onGround then
			caster.iceDirection = direction
		else
		end
		local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		caster.iceSpeed = math.min(caster.iceSpeed + speedGain, caster.ice_speed_slip_max)
		-- print(caster.iceSpeed)
		if distance > 300 then
			caster.iceSpeed = 0
		end
		local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
	    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+caster.iceDirection*caster.iceSpeed), caster)
	    if blockUnit then
	    	caster.iceSpeed = 0
	    end
		caster.iceInterval = caster.iceInterval + 1
		if caster.iceInterval >= 25 and caster.iceSpeed > 0 then
			StartAnimation(caster, {duration=0.75, activity=ACT_DOTA_RUN, rate=2.8})
			caster.iceInterval = 0
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.IceSkate", Winterblight.Master)
		end
		if caster.iceInterval%8 == 0 and caster.iceSpeed > 0 then
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/ice_slip_flash_c.vpcf", caster:GetAbsOrigin()-caster:GetForwardVector()*50, 1)
		end
		if caster.iceSpeed > 0.5 then
			local friction = 0.15
			if onGround then
				caster.iceSpeed = math.max(caster.iceSpeed - friction, 0)
				caster.iceDirection = (caster.iceDirection + caster:GetForwardVector()*turn_rate):Normalized()
				if caster.iceSpeed == 0 then
					FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
				end
			end
			-- print(caster.iceDirection*caster.iceSpeed)
			local angleDiff = math.abs(AngleDiff(WallPhysics:vectorToAngle(caster.iceDirection), WallPhysics:vectorToAngle(caster:GetForwardVector())))
			-- print(angleDiff)
			if AngleDiff(WallPhysics:vectorToAngle(caster.iceDirection), WallPhysics:vectorToAngle(caster:GetForwardVector())) > 15 and onGround then
			else
				local newPos = caster:GetAbsOrigin()+caster.iceDirection*caster.iceSpeed
				if onGround then
					newPos = GetGroundPosition(newPos, caster)
				end

				if math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 60 then
					caster:SetOrigin(caster:GetAbsOrigin()+caster.iceDirection*caster.iceSpeed)
				else
					caster.iceSpeed = 0
					FindClearSpaceForUnit(caster, caster:GetAbsOrigin()-caster.iceDirection*30, false)
				end
			end
		else
			caster.iceSpeed = 0
			if onGround and math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 10 then
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end
		end
		caster.icePrevPosition = caster:GetAbsOrigin()
		if caster.iceRightClickPos then
			if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.iceRightClickPos) < 20 + caster.iceSpeed then
				caster.iceRightClickPos = nil
				caster:Stop()
			end
		end
	end
end