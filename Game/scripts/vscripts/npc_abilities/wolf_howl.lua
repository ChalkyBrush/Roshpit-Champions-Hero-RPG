function HowlBegin(event)
	caster = event.caster
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_SPAWN, rate=0.5})
end