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
	EmitSoundOn("Jex.MeteorShower.Start", caster)
	local w_4_level = caster:GetRuneValue("w", 4)
	local e_4_level = caster:GetRuneValue("e", 4)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.2})
	end)
	local tech_level = onibi_get_total_tech_level(caster, "fire", "cosmic", "Q")
	local meteors = event.base_meteors + event.meteors_per_tech*tech_level
	local stun_duration = event.e_4_stun_duration*e_4_level

    local damage = event.base_damage + event.strength_added_to_damage*caster:GetStrength() + (event.attack_damage_percent_added_per_tech/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
	if w_4_level > 0 then
		damage = damage + (event.w_4_base_damage_increase/100)*w_4_level
	end

	local meteor_delay = 0.15

	for i = 1, meteors, 1 do
		Timers:CreateTimer((i-1)*meteor_delay, function()
			local target = ability.meteor_showers_table[RandomInt(1, #ability.meteor_showers_table)].position + RandomVector(RandomInt(1, 600))
			EmitSoundOnLocationWithCaster(target, "Jex.Meteor.Fall", caster)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/jex/jex_fire_cosmic_q_meteor_attack.vpcf", target, 4)
			Timers:CreateTimer(0.45, function()
				EmitSoundOnLocationWithCaster(target, "Jex.MeteorShower.Impact", caster)
				CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", target, 3)
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_COSMOS)
						if stun_duration > 0 then
							Filters:ApplyStun(caster, stun_duration, enemy)
						end
					end
				end 	
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

