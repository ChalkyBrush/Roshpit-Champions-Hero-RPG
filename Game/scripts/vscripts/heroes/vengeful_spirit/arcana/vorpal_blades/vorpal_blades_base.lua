require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
vorpal_blades_base = class(base_ability)

modifier_solunia_arcana_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_arcana_w_passive", "heroes/vengeful_spirit/arcana/vorpal_blades/vorpal_blades_base.lua", LUA_MODIFIER_MOTION_NONE)

function vorpal_blades_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solonua_vorpal_blades_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solonua_vorpal_blades_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	else
		return false
	end
end

function vorpal_blades_base:GetManaCostBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return SOLUNIA_ARCANA_W_MANA_COST[level + 1]
end

function vorpal_blades_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function vorpal_blades_base:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function vorpal_blades_base:GetAbilitySlot()
    return DOTA_W_SLOT
end

function vorpal_blades_base:GetCastPoint()
	return 0
end

function vorpal_blades_base:GetCooldownBase(level)
    return 0.5
end

function vorpal_blades_base:GetIntrinsicModifierName()
	return "modifier_solunia_arcana_w_passive"
end

function vorpal_blades_base:GetTotalMaxBlades()
	return self:GetSpecialValueFor("max_blades")
end

function vorpal_blades_base:GetVorpalsForThisThrow(total_max_blades)
	return math.min(3, total_max_blades-#self.vorpals)
end

function vorpal_blades_base:GetTotalDamage()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("damage") + (self:GetSpecialValueFor("atk_power_added_to_dmg")/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
end

function vorpal_blades_base:GetBladeBounceCount()
	return self:GetSpecialValueFor("base_bounces")
end

function vorpal_blades_base:CastVorpalBlades()
	local caster = self:GetCaster()
	local ability = self

	StartAnimation(caster, {duration = 0.2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2.2})

	local vorpal_particle = self:GetProjectileParticleName()

	local baseFV = caster:GetForwardVector()
	local search_area = caster:GetAbsOrigin()
	local search_radius = self:GetSpecialValueFor("search_radius")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), search_area, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	caster:AddNewModifier(caster, ability, self:GetThinkerModifierName(), {})

	if not ability.vorpals then
		ability.vorpals = {}
	end
	local total_max_blades = self:GetTotalMaxBlades()

	local vorpals_for_this_throw = self:GetVorpalsForThisThrow(total_max_blades)

	local damage = self:GetTotalDamage()
	-- local w_1_level = caster:GetRuneValue("w", 1)
	-- damage = damage + w_1_level*(SOLUNIA_ARCANA_W1_ATK_DMG_ADDED_TO_VORPAL_PCT/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)

	-- local w_2_level = caster:GetRuneValue("w", 2)
	-- damage = damage + w_2_level * (SOLUNIA_ARCANA_W2_CURRENT_MANA_ADDED_TO_DAMAGE_PCT / 100) * caster:GetMana()
	-- local mana_restore = w_2_level * (SOLUNIA_ARCANA_W2_MANA_RESTORE_PER_HIT)
	-- local w_3_level = caster:GetRuneValue("w", 3)

	-- local bounces = event.base_bounces
	-- local w_4_level = caster:GetRuneValue("w", 4)
	
	for i = 1, vorpals_for_this_throw do
		local vorpal = {}
		local vorpal_distance = 1300
		local vorpal_fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/3)
		local vorpal_target = caster:GetAbsOrigin()+vorpal_fv*vorpal_distance + Vector(0,0,160)
		local vorpal_speed = 1000
		local vorpal_origin = caster:GetAbsOrigin() + Vector(0,0,160)

		-- local bounces = event.base_bounces
		-- bounces = bounces + Runes:Procs(w_4_level, SOLUNIA_ARCANA_W4_EXTRA_BOUNCE_CHANCE, 1)

		vorpal.active = true
		vorpal.speed = vorpal_speed
		vorpal.position = vorpal_origin
		vorpal.target = vorpal_target
		vorpal.interval = 0
		vorpal.damage = damage

		-- vorpal.mana_restore = mana_restore
		-- vorpal.w_3_level = w_3_level
		local pfx = ParticleManager:CreateParticle(vorpal_particle, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector())
		ParticleManager:SetParticleControl(pfx, 1, vorpal_target)
		ParticleManager:SetParticleControl(pfx, 2, Vector(vorpal_speed, vorpal_speed, vorpal_speed))
		vorpal.pfx = pfx
		vorpal.targets_hit = 0
		vorpal.bounces = self:GetBladeBounceCount()
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

	ability:RecalculateOutstandingVorpals()
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function vorpal_blades_base:RecalculateOutstandingVorpals()
	local caster = self:GetCaster()
	local ability = self
	if #ability.vorpals > 0 then
		caster:AddNewModifier(caster, self, self:GetCounterModifierName(), {})
		caster:SetModifierStackCount(self:GetCounterModifierName(), caster, #ability.vorpals)
	else
		caster:RemoveModifierByName(self:GetCounterModifierName())
		caster:RemoveModifierByName(self:GetThinkerModifierName())
	end
end

-- PROCESSOR MODIFIER

function vorpal_blades_base:VorpalThinker()
	local caster = self:GetCaster()
	local ability = self
	local new_vorpal_table = {}
	local think_interval = 0.2
	for i = 1, #ability.vorpals, 1 do
		local vorpal = ability.vorpals[i]
		if vorpal.active then
			vorpal.speed = math.min(vorpal.speed + 70, 1300)
			local direction = (vorpal.target - vorpal.position):Normalized()
			vorpal.position = vorpal.position + vorpal.speed*think_interval*direction
			vorpal.interval = vorpal.interval + 1

			if vorpal.interval >= 2 then
				if IsValidEntity(vorpal.lock_entity) and vorpal.lock_entity:IsAlive() then
					vorpal.target = vorpal.lock_entity:GetAbsOrigin()
				end
			end
			if vorpal.interval >= 120 then
				vorpal.active = false
			end

			local distance = WallPhysics:GetDistance2d(vorpal.position, vorpal.target)
			if vorpal.lock_entity then
				print(vorpal.interval)
				print(vorpal.lock_entity:GetUnitName())
				print(vorpal.active)
				print(distance)
			end			
			if distance <= (vorpal.speed*think_interval) then
				if vorpal.targets_hit < (vorpal.bounces) then
					
					local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), vorpal.position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
					local new_target = nil
					if #nearby_enemies > 0 then
						if IsValidEntity(vorpal.lock_entity) then
							for _, enemy in pairs(nearby_enemies) do
								if enemy:GetEntityIndex() ~= vorpal.lock_entity:GetEntityIndex() then
									new_target = enemy
									break
								end
							end
						else
							new_target = nearby_enemies[1]
						end
					end
					if vorpal.lock_entity then
						print(vorpal.lock_entity:GetUnitName())
					end
					if IsValidEntity(vorpal.lock_entity) then
						vorpal.targets_hit = vorpal.targets_hit + 1
						EmitSoundOn("Solunia.Arcana3.Vorpal.Hit", vorpal.lock_entity)
						EmitSoundOn("Solunia.Arcana3.Vorpal.Hit.Highlight", vorpal.lock_entity)
						local damage = vorpal.damage
						-- if vorpal.w_3_level > 0 then
						-- 	local luck = RandomInt(1, 100)
						-- 	if luck <= SOLUNIA_ARCANA_W3_CRIT_CHANCE then
						-- 		damage = damage + damage*(SOLUNIA_ARCANA_W3_CRIT_DMG/100)*vorpal.w_3_level
						-- 		CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/vorpal_crit_blur.vpcf", vorpal.lock_entity, 3)
						-- 		if caster:HasModifier("modifier_solunia_immortal_weapon_2") then
						-- 			caster.origCaster = caster
						-- 			immo_weapon_2_effect(caster, vorpal.lock_entity)
						-- 		end
						-- 		EmitSoundOn("Solunia.BoomerangCrit", vorpal.lock_entity)
						-- 		PopupDamage(vorpal.lock_entity, math.floor(damage))
						-- 	end
						-- end
						Filters:TakeArgumentsAndApplyDamage(vorpal.lock_entity, caster, damage, self:GetAbilityDamageType(), BASE_ABILITY_W, self:GetAbilityElement(1), self:GetAbilityElement(2))
						-- if vorpal.mana_restore > 0 then
						-- 	caster:GiveMana(vorpal.mana_restore)
						-- 	PopupMana(caster, vorpal.mana_restore)
						-- end

					end
					if IsValidEntity(new_target) then
						vorpal.interval = math.ceil(vorpal.interval/2)
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
	ability:RecalculateOutstandingVorpals()
end