require('heroes/slardar/arcana/flood_basin')
require('heroes/slardar/hydroxis_constants')

function begin_hydro_pump(event)
	local caster = event.caster
	local ability = event.ability

	caster:RemoveModifierByName("modifier_hydroxis_b_a_shield_visible")
	caster:RemoveModifierByName("modifier_hydroxis_b_a_shield_visible_glyphed")
	caster:RemoveModifierByName("modifier_hydroxis_b_a_shield_invisible")
	ability.q_2_level = caster:GetRuneValue("q", 2)
	ability.q_3_level = caster:GetRuneValue("q", 3)
	caster.e_4_Level = caster:GetRuneValue("e", 4)
	local q_4_level = caster:GetRuneValue("q", 4)
	local procs = Runes:Procs(q_4_level, HYDROXIS_Q4_MULTI_CAST_PCT, 1)
	local damage = event.damage
	damage = damage + (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() + caster:GetSpirit()) * HYDROXIS_Q4_ADD_DMG_PER_ATTR * q_4_level
	local targetPoint = event.target_points[1]
	local pumpDelay = 0.9
	if caster:HasModifier("modifier_hydroxis_immortal_weapon_3") then
		pumpDelay = pumpDelay * (100-HYDROXIS_IMMORTAL_WEAPON_3_Q_DELAY_REDUCTION_PCT)/100
	end
	for j = 0, procs, 1 do
		Timers:CreateTimer(0.9 * j, function()
			if j > 0 then
				StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.4})
			end
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)


			local spellStartPoint = caster:GetAbsOrigin()
			local fv = caster:GetForwardVector()
			EmitSoundOn("Hydroxis.HydroPump.Start", caster)
			local loops = event.torrents
			for i = 0, loops - 1, 1 do
				Timers:CreateTimer(i * pumpDelay, function()
					local hydroPosition = spellStartPoint + fv * 240 * (i + 1) - Vector(0, 0, 0)
					hydroPosition = GetGroundPosition(hydroPosition, caster)
					EmitSoundOnLocationWithCaster(hydroPosition, "Hydroxis.HydroPump.Pump", caster)
					local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, hydroPosition)
					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hydroPosition, nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							if not enemy.jumpLock then
								if enemy:GetAbsOrigin().z - GetGroundHeight(enemy:GetAbsOrigin(), enemy) < 500 then
									if not Filters:HasFlyingModifier(enemy) then
										ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_stun", {duration = 4})
										ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_lifting", {duration = 2})
										enemy.torrentLiftVelocity = 16
									end
								end
							end
							Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
							if ability.q_3_level > 0 then
								ability:ApplyDataDrivenModifier(caster, enemy, "modifier_hydroxis_c_a_magic_resist_lost", {duration = 8})
								enemy:SetModifierStackCount("modifier_hydroxis_c_a_magic_resist_lost", caster, ability.q_3_level)
							end
						end
					end
					if ability.q_2_level > 0 then
						local allies = FindUnitsInRadius(caster:GetTeamNumber(), hydroPosition, nil, 270, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
						if #allies > 0 then
							for _, ally in pairs(allies) do
								if ally:GetEntityIndex() == caster:GetEntityIndex() then
									local newStacks = 0
									if not caster:HasModifier("modifier_hydroxis_glyph_3_1") then
										ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_b_a_shield_visible", {duration = 12})
										newStacks = caster:GetModifierStackCount("modifier_hydroxis_b_a_shield_visible", caster) + 1
										caster:SetModifierStackCount("modifier_hydroxis_b_a_shield_visible", caster, newStacks)
									else
										ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_b_a_shield_visible_glyphed", {duration = 12})
										newStacks = caster:GetModifierStackCount("modifier_hydroxis_b_a_shield_visible_glyphed", caster) + (HYDROXIS_GLYPH_3_1_Q2_TICKRATE_MULT-1)
										caster:SetModifierStackCount("modifier_hydroxis_b_a_shield_visible_glyphed", caster, newStacks)
									end

									ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_b_a_shield_invisible", {duration = 12})
									caster:SetModifierStackCount("modifier_hydroxis_b_a_shield_invisible", caster, newStacks * ability.q_2_level)
								end
							end
						end
					end
				end)
			end
		end)
	end
	ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "hydroxis")
	if ability.q_1_level > 0 then
		if caster:HasModifier("modifier_hydroxis_arcana2") then
			local eventTable = {}
			eventTable.ability = caster:FindAbilityByName("hydroxis_spellbound_flood_basin")
			eventTable.radius = 350
			eventTable.caster = caster
			eventTable.target_position = targetPoint
			eventTable.alt_particle = true
			flood_basin_start(eventTable)
		else
			local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx2, 0, targetPoint)
			ParticleManager:SetParticleControl(pfx2, 1, Vector(240, 4, 4))

			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetPoint, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			local oceanQuake = caster:FindAbilityByName("hydroxis_tsunami")
			local damage = oceanQuake:GetSpecialValueFor("strength_damage") * caster:GetStrength() * ability.q_1_level * HYDROXIS_Q1_DMG_PCT/100
			local stunDuration = oceanQuake:GetSpecialValueFor("stun_duration")
			local slow_duration = oceanQuake:GetSpecialValueFor("slow_duration")
			slow_duration = slow_duration + stunDuration
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_WATER, RPC_ELEMENT_EARTH)
					Filters:ApplyStun(caster, stunDuration, enemy)
					oceanQuake:ApplyDataDrivenModifier(caster, enemy, "modifier_ocean_quake_slowed", {duration = slow_duration})
				end
			end
			Timers:CreateTimer(5, function()
				ParticleManager:DestroyParticle(pfx2, false)
				ParticleManager:ReleaseParticleIndex(pfx2)
			end)
		end
	end
	Filters:CastSkillArguments(1, caster)
end

function torrent_stun_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, target.torrentLiftVelocity))
	target.torrentLiftVelocity = target.torrentLiftVelocity - 0.5
	if target.torrentLiftVelocity < 0 then
		target:RemoveModifierByName("modifier_torrent_lifting")
	end
	if not target:HasModifier("modifier_torrent_lifting") then
		if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < 30 then
			target:RemoveModifierByName("modifier_torrent_stun")
		end
	end
end

function torrent_stun_end(event)
	local target = event.target
	local ability = event.ability
	Timers:CreateTimer(0.06, function()
		target.torrentLiftVelocity = nil
	end)

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(70, 70, 70))
	Timers:CreateTimer(3.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

end

function hydroxis_animation_think(event)
	local caster = event.caster
	local movespeed = caster:GetBaseMoveSpeed()
	local movespeedModifier = caster:GetMoveSpeedModifier(movespeed, false)
	if movespeedModifier < 420 then
		caster:RemoveModifierByName("modifier_animation_translate")
	else
		if not caster:HasModifier("modifier_animation_translate") then
			caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "sprint"})
		end
	end
	local d_c_Level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "hydroxis")
	if d_c_Level > 0 then
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_d_c", {})
		caster:SetModifierStackCount("modifier_hydroxis_d_c", caster, d_c_Level)
	else
		caster:RemoveModifierByName("modifier_hydroxis_d_c")
	end
end

function mystic_water_shield_think(event)
	local caster = event.caster
	local ability = event.ability
	local stacks = caster:GetModifierStackCount("modifier_hydroxis_b_a_shield_visible", caster) + caster:GetModifierStackCount("modifier_hydroxis_b_a_shield_visible_glyphed", caster)
	local healAmount = ability.q_2_level * HYDROXIS_Q2_HEAL * stacks
	Filters:ApplyHeal(caster, caster, healAmount, true)
	-- PopupHealing(caster, healAmount)
	CustomAbilities:QuickAttachParticle("particles/roshpit/hydroxis/mystic_water_shield_heal.vpcf", caster, 1)
end
