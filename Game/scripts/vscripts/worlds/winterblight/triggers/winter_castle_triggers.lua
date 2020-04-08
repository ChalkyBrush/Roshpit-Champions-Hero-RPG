function CastlePortalSwitchTrigger(trigger)
	local hero = trigger.activator
	local caller = trigger.caller
	if Winterblight.CastleSwitchPressed then
		return false
	else
		Winterblight.CastleSwitchPressed = true
		Winterblight:ActivateSwitchGeneric(hero:GetAbsOrigin(), "CastleSwitchProp1", true, 0.352)
		Timers:CreateTimer(2, function()
			Winterblight.CastlePortalsActive = true
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(12891, 2332, 1820 + Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(12891, 2332, 1850 + Winterblight.ZFLOAT), 300, 99999, false)
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(14048, 13254, 1640 + Winterblight.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(14048, 13254, 1850 + Winterblight.ZFLOAT), 300, 99999, false)
		end)
	end
end

function CastlePortal1(trigger)
	local activator = trigger.activator
	local caller = trigger.caller
	if activator:HasModifier("modifier_recently_teleported_portal") then
		return false
	end
	if not Winterblight.CastlePortalsActive then
		return false
	end
	if WallPhysics:GetDistance2d(caller:GetAbsOrigin(), activator:GetAbsOrigin()) < 200 then
		local tp_position = Vector(12891, 2331, 1800)
		Events:TeleportUnit(activator, tp_position, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function CastlePortal2(trigger)
	local activator = trigger.activator
	local caller = trigger.caller
	if activator:HasModifier("modifier_recently_teleported_portal") then
		return false
	end
	if not Winterblight.CastlePortalsActive then
		return false
	end
	if WallPhysics:GetDistance2d(caller:GetAbsOrigin(), activator:GetAbsOrigin()) < 200 then
		local tp_position = Vector(14048, 13254, 1680)
		Events:TeleportUnit(activator, tp_position, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end