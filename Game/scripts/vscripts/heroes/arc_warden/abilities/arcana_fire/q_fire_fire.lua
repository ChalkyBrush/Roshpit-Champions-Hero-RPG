require('heroes/arc_warden/abilities/onibi')
require('heroes/arc_warden/jex_constants')

function jex_activate_q_fire_fire(event)
	local caster = event.caster
	local ability = event.ability

	local attack_damage_per_tech = event.attack_damage_per_tech
	local radius = event.radius
	local radius_per_tech = event.radius_per_tech
	local base_damage = event.base_damage
	local agility_added_to_base_damage = event.agility_added_to_base_damage

	local tech_level = onibi_get_total_tech_level(caster, "fire", "fire", "Q")
	local total_radius = radius + radius_per_tech*tech_level
	local damage = base_damage + agility_added_to_base_damage*caster:GetAgility() + (attack_damage_per_tech/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)

	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		damage = damage + damage*(event.w_4_damage_increase_pct/100)*w_4_level
	end
	ability.damage = damage

	if not ability.ring_table then
		ability.ring_table = {}

	end
	local new_ring = {}
	new_ring.active = true
	new_ring.pfx = ParticleManager:CreateParticle("particles/roshpit/jex/ring_of_fire_reduced_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	table.insert(ability.ring_table, new_ring)
	local ringDuration = 0
	local radius = 1800
	local speed = radius*1.5
    ParticleManager:SetParticleControl(new_ring.pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(new_ring.pfx, 1, Vector(speed, radius, 600))
    Timers:CreateTimer(ringDuration+(radius/speed), function()
    	ParticleManager:SetParticleControl(new_ring.pfx, 1, Vector(speed, -radius, 600))
    	Timers:CreateTimer(radius/speed, function()
	    	new_ring.active = false
	    	ParticleManager:DestroyParticle(new_ring.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(new_ring.pfx)
	    	reindex_fire_fire_q_table(ability)
	    end)
    end)	
	
end

function reindex_fire_fire_q_table(ability)
	local new_table = {}
	for i = 1, #ability.ring_table, 1 do
		if ability.ring_table[i].active then
			table.insert(new_table, ability.ring_table[i])
		end
	end
	ability.ring_table = new_table
end

function jex_fire_fire_q_thinker(event)

end

