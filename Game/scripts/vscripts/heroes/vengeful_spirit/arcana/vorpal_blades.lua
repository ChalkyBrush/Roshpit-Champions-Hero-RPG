require('/heroes/vengeful_spirit/solunia_constants')
require('/heroes/vengeful_spirit/boomerang')

function start_vorpal_blades(event)
	local caster = event.caster
	local ability = event.ability

	StartAnimation(caster, {duration = 0.2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2.2})

	local vorpal_particle = "particles/econ/items/luna/luna_ti9_weapon_gold/luna_ti9_gold_moon_glaive_bounce.vpcf"

	local baseFV = caster:GetForwardVector()
	local search_area = caster:GetAbsOrigin()
	local search_radius = event.search_radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), search_area, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if event.type == "sun" then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorpal_blade_thinker_solar", {})
	elseif event.type == "moon" then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_vorpal_blade_thinker_lunar", {})
		vorpal_particle = "particles/econ/items/luna/luna_ti9_weapon/luna_ti9_moon_glaive_bounce.vpcf"
	end

	if not ability.vorpals then
		ability.vorpals = {}
	end
	local total_max_blades = event.max_blades
	if caster:HasModifier("modifier_solunia_glyph_1_1") then
		total_max_blades = total_max_blades + SOLUNIA_GLYPH_1_1_W_BLADES_ADDED
	end
	local vorpals_for_this_throw = math.min(3, total_max_blades-#ability.vorpals)

	local damage = event.damage
	local w_1_level = caster:GetRuneValue("w", 1)
	damage = damage + w_1_level*(SOLUNIA_ARCANA_W1_ATK_DMG_ADDED_TO_VORPAL_PCT/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)

	local w_2_level = caster:GetRuneValue("w", 2)
	damage = damage + w_2_level * (SOLUNIA_ARCANA_W2_CURRENT_MANA_ADDED_TO_DAMAGE_PCT / 100) * caster:GetMana()
	local mana_restore = w_2_level * (SOLUNIA_ARCANA_W2_MANA_RESTORE_PER_HIT)
	local w_3_level = caster:GetRuneValue("w", 3)

	local bounces = event.base_bounces
	local w_4_level = caster:GetRuneValue("w", 4)
	
	for i = 1, vorpals_for_this_throw do
		local vorpal = {}
		local vorpal_distance = 1300
		local vorpal_fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/3)
		local vorpal_target = caster:GetAbsOrigin()+vorpal_fv*vorpal_distance + Vector(0,0,160)
		local vorpal_speed = 1000
		local vorpal_origin = caster:GetAbsOrigin() + Vector(0,0,160)

		local bounces = event.base_bounces
		bounces = bounces + Runes:Procs(w_4_level, SOLUNIA_ARCANA_W4_EXTRA_BOUNCE_CHANCE, 1)

		vorpal.active = true
		vorpal.speed = vorpal_speed
		vorpal.position = vorpal_origin
		vorpal.target = vorpal_target
		vorpal.interval = 0
		vorpal.damage = damage
		vorpal.mana_restore = mana_restore
		vorpal.w_3_level = w_3_level
		vorpal.type = event.type
		local pfx = ParticleManager:CreateParticle(vorpal_particle, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector())
		ParticleManager:SetParticleControl(pfx, 1, vorpal_target)
		ParticleManager:SetParticleControl(pfx, 2, Vector(vorpal_speed, vorpal_speed, vorpal_speed))
		vorpal.pfx = pfx
		vorpal.targets_hit = 0
		vorpal.bounces = bounces
		if #enemies > 0 then
			local lock_target = enemies[RandomInt(1, #enemies)]
			vorpal.lock_entity = lock_target
		else
			vorpal.lock_entity = nil
		end
		table.insert(ability.vorpals, vorpal)
	end
	if vorpals_for_this_throw > 0 then
		EmitSoundOn("Solunia.Arcana3.Vorpal.Cast", caster)
	else
		EmitSoundOn("Solunia.Arcana3.Vorpal.CastNone", caster)
	end
	local counter_modifier_name = "modifier_active_sun_vorpals"
	if event.type == "moon" then
		counter_modifier_name = "modifier_active_moon_vorpals"
	end
	ability:ApplyDataDrivenModifier(caster, caster, counter_modifier_name, {})
	caster:SetModifierStackCount(counter_modifier_name, caster, #ability.vorpals)
	Filters:CastSkillArguments(2, caster)
end

function vorpal_blades_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local new_vorpal_table = {}
	local think_interval = 0.2

	local damage = event.damage
	local element2 = RPC_ELEMENT_FIRE
	local damagetype = DAMAGE_TYPE_MAGICAL
	if event.type == "moon" then
		element2 = RPC_ELEMENT_ICE
		damagetype = DAMAGE_TYPE_PURE
	end
	for i = 1, #ability.vorpals, 1 do
		local vorpal = ability.vorpals[i]
		if vorpal.active then
			vorpal.speed = math.min(vorpal.speed + 70, 1300)
			local direction = (vorpal.target - vorpal.position):Normalized()
			vorpal.position = vorpal.position + vorpal.speed*think_interval*direction
			vorpal.interval = vorpal.interval + 1

			if vorpal.interval >= 3 then
				if IsValidEntity(vorpal.lock_entity) and vorpal.lock_entity:IsAlive() then
					vorpal.target = vorpal.lock_entity:GetAbsOrigin()
				end
			end
			if vorpal.interval >= 120 then
				vorpal.active = false
			end

			local distance = WallPhysics:GetDistance2d(vorpal.position, vorpal.target)
			
			if distance <= (vorpal.speed*think_interval) then
				-- CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", vorpal.position, 3)
				if vorpal.targets_hit < (vorpal.bounces - 1) then
					vorpal.targets_hit = vorpal.targets_hit + 1
					local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), vorpal.position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					local new_target = nil
					if #nearby_enemies > 0 then
						if IsValidEntity(vorpal.lock_entity) then
							for _, enemy in pairs(nearby_enemies) do
								if enemy:GetEntityIndex() ~= vorpal.lock_entity:GetEntityIndex() then
									new_target = enemy
									break
								end
								-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
							end
						else
							new_target = nearby_enemies[1]
						end
					end
					if IsValidEntity(vorpal.lock_entity) then
						EmitSoundOn("Solunia.Arcana3.Vorpal.Hit", vorpal.lock_entity)
						EmitSoundOn("Solunia.Arcana3.Vorpal.Hit.Highlight", vorpal.lock_entity)
						local damage = vorpal.damage
						if vorpal.w_3_level > 0 then
							local luck = RandomInt(1, 100)
							if luck <= 20 then
								damage = damage + damage*(SOLUNIA_ARCANA_W3_CRIT_DMG/100)*vorpal.w_3_level
								CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/vorpal_crit_blur.vpcf", vorpal.lock_entity, 3)
								if caster:HasModifier("modifier_solunia_immortal_weapon_2") then
									immo_weapon_2_effect(caster, vorpal.lock_entity)
								end
								EmitSoundOn("Solunia.BoomerangCrit", vorpal.lock_entity)
								PopupDamage(vorpal.lock_entity, math.floor(damage))
							end
						end
						Filters:TakeArgumentsAndApplyDamage(vorpal.lock_entity, caster, damage, damagetype, BASE_ABILITY_W, RPC_ELEMENT_COSMOS, element2)
						if vorpal.mana_restore > 0 then
							caster:GiveMana(vorpal.mana_restore)
							PopupMana(caster, vorpal.mana_restore)
						end

					end
					if IsValidEntity(new_target) then
						vorpal.lock_entity = new_target
						vorpal.target = vorpal.lock_entity:GetAbsOrigin()
					else
						vorpal.active = false
					end

				else
					vorpal.active = false
				end
			end
			if vorpal.active then
				ParticleManager:SetParticleControl(vorpal.pfx, 1, vorpal.target)
				ParticleManager:SetParticleControl(vorpal.pfx, 2, Vector(vorpal.speed, vorpal.speed, vorpal.speed))
				table.insert(new_vorpal_table, vorpal)
			else
				ParticleManager:DestroyParticle(vorpal.pfx, false)
				ParticleManager:ReleaseParticleIndex(vorpal.pfx)	
			end			
		end
	end
	ability.vorpals = new_vorpal_table

	local counter_modifier_name = "modifier_active_sun_vorpals"
	if event.type == "moon" then
		counter_modifier_name = "modifier_active_moon_vorpals"
	end
	if #ability.vorpals > 0 then
		caster:SetModifierStackCount(counter_modifier_name, caster, #ability.vorpals)
	else
		caster:RemoveModifierByName(counter_modifier_name)
	end
end