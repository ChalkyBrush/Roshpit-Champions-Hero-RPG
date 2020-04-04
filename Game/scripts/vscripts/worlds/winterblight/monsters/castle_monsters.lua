function diviner_think(event)
	local caster = event.caster
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 5, false)
end