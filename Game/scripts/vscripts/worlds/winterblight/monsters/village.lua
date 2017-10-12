function village_snowball_hit(event)
	local target = event.target
	local caster = event.caster
	EmitSoundOn("Villager.Laugh", caster)
	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_FLAIL, rate=1.8})
end

