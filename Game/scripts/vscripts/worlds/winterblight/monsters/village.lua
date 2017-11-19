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

