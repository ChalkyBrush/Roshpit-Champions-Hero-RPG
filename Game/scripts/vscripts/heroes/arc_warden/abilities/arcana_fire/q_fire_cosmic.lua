require('heroes/arc_warden/abilities/onibi')

function jex_fire_cosmic_q_phase(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.97, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
	local point = event.target_points[1]

	ability.point = point
	StartSoundEvent("Jex.Meteor.CastStart", caster)
	if not ability.meteor_showers_table then
		ability.meteor_showers_table = {}
	end
	new_meteor_shower = {}
	new_meteor_shower.position = point
	new_meteor_shower.meteors = 10
	new_meteor_shower.pfx = ParticleManager:CreateParticle("particles/roshpit/jex/jex_meteor_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(new_meteor_shower.pfx, 0, point)
	
	ability.casting_shower = new_meteor_shower
	CustomAbilities:QuickAttachParticle("particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_flash.vpcf", caster, 2)
end

function jex_fire_cosmic_q_phase_interrupt(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.4})
	local point = event.target_points[1]
	-- EndAnimation(caster)
	ParticleManager:DestroyParticle(ability.casting_shower.pfx, false)
	StopSoundEvent("Jex.Meteor.CastStart", caster)
	
end

function jex_activate_q_fire_cosmic(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", caster:GetAbsOrigin(), 3)
	table.insert(ability.meteor_showers_table, new_meteor_shower)
	local tech_level = onibi_get_total_tech_level(caster, "fire", "cosmic", "Q")
	EmitSoundOn("Jex.Grunt", caster)
	local w_4_level = caster:GetRuneValue("w", 4)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.2})
	end)
	local meteors = 20
	local meteor_delay = 0.27
	for i = 1, meteors, 1 do
		Timers:CreateTimer((i-1)*meteor_delay, function()
			local target = ability.meteor_showers_table[RandomInt(1, #ability.meteor_showers_table)].position + RandomVector(RandomInt(1, 600))
			EmitSoundOnLocationWithCaster(target, "Jex.Meteor.Fall", caster)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/jex/jex_fire_cosmic_q_meteor_attack.vpcf", target, 4)
			Timers:CreateTimer(0.45, function()
				EmitSoundOnLocationWithCaster(target, "Jex.Meteor.Impact", caster)
			end)		
		end)
	end
	Timers:CreateTimer(meteor_delay*meteors, function()
		ParticleManager:DestroyParticle(ability.meteor_showers_table[1].pfx, false)
		local new_meteors_table = {}
		for i = 2, #ability.meteor_showers_table, 1 do
			table.insert(new_meteors_table, ability.meteor_showers_table[i])
		end
		ability.meteor_showers_table = new_meteors_table
	end)
	Filters:CastSkillArguments(1, caster)
end

