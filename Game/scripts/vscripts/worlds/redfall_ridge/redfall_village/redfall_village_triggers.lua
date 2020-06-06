function RedfallFarmlandsTeleportTriggerOnStartTouch(trigger)
	local hero = trigger.activator
	if Redfall.FarmlandsPortalActive and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(-61, -7275)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end