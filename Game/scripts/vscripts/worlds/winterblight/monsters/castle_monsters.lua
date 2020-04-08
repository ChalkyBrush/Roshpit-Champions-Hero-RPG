function diviner_think(event)
	local caster = event.caster
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 5, false)
end

function winterblight_castle_dungeon_master_main_thinker(event)
	local caster = event.caster
	if not caster.think_interval then
		caster.think_interval = 0
	end
	caster.think_interval = caster.think_interval + 1

	if caster.think_interval%30 == 0 then
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", Vector(14639, 12340, 1520), 3)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", Vector(15237, 9998, 2080), 3)
	end
	if caster.think_interval == 200 then
		caster.think_interval = 0
	end
end