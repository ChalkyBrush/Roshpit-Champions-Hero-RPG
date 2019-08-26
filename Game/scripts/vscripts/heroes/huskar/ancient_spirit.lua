require('heroes/huskar/windstrike')
require('/heroes/huskar/spirit_warrior_constants')

function cast_ancient_spirit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local cooldown = event.cooldown
	if not ability.spiritTable then
		ability.spiritTable = {}
	end
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 180, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local targetedSpirit = false
	for i = 1, #allies, 1 do
		if allies[i]:GetUnitName() == "spirit_warrior_spirit" then
			targetedSpirit = allies[i]
			break
		end
	end
	if targetedSpirit then
		Filters:CastSkillArguments(3, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_dashing", {duration = 3.4})
		caster:RemoveModifierByName("modifier_spirit_warrior_glyph_effect")
		ability.targetedSpirit = targetedSpirit
		local soundTable = {"SpiritWarrior.SpiritYell1", "SpiritWarrior.SpiritYell2", "SpiritWarrior.SpiritYell3"}
		EmitSoundOn(soundTable[RandomInt(1, 3)], caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.AncientSpiritJumping", caster)
	else
		-- Filters:ReduceECooldown(caster, ability, cooldown, true)
		EmitSoundOn("SpiritWarrior.AncientSpiritCast", caster)
		local spirit = CreateUnitByName("spirit_warrior_spirit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
		spirit:SetOwner(caster)
		spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
		ancient_spirit_particle(spirit:GetAbsOrigin(), caster)
		local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		spirit:SetForwardVector(fv)
		ability:ApplyDataDrivenModifier(caster, spirit, "modifier_ancient_spirit_spirit", {})
		if not caster:HasModifier("modifier_ancient_vigor") then
			ability:ApplyDataDrivenModifier(caster, spirit, "modifier_ancient_spirit_disarm", {})
		else
			local duration = caster:FindModifierByName("modifier_ancient_vigor"):GetRemainingTime()
			ability:ApplyDataDrivenModifier(caster, spirit, "modifier_spirit_attacking", {})
			local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "spirit_warrior")
			spirit.r_3_level = c_d_level
			local vigor_ability = caster:FindAbilityByName("spirit_warrior_ancient_vigor")
			if vigor_ability then
				local r_4_level = caster:GetRuneValue("r", 4)
				if r_4_level > 0 then
					vigor_ability:ApplyDataDrivenModifier(caster, spirit, "modifier_ancient_spirit_attackspeed", {duration = duration})
					spirit:SetModifierStackCount("modifier_ancient_spirit_attackspeed", caster, r_4_level)
				end
			end
		end
		-- spirit:AddNewModifier( spirit, nil, 'modifier_movespeed_cap', nil )
		Timers:CreateTimer(0.05, function()
			StartAnimation(spirit, {duration = 5, activity = ACT_DOTA_RUN, rate = 1.4, translate = "haste"})
		end)
		ability:ApplyDataDrivenModifier(caster, spirit, "modifier_spirit_moving_out", {})
		spirit.targetPoint = target
		spirit.origCaster = caster
		for i = 1, 20, 1 do
			Timers:CreateTimer(i * 0.03, function()
				spirit:SetModelScale(0.3 + (i * 0.02))
			end)
		end

		table.insert(ability.spiritTable, spirit)

		local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "spirit_warrior")
		if b_c_level > 0 then
			local spiritAbility = spirit:AddAbility("spirit_warrior_b_c_special")
			spiritAbility.level = b_c_level
			spiritAbility:SetLevel(1)
		end
		-- local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "spirit_warrior")
		-- if c_c_level > 0 then
		-- local runeAbility = caster.runeUnit3:FindAbilityByName("spirit_warrior_rune_e_3")
		-- runeAbility.level = c_c_level
		-- runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, spirit, "modifier_spirit_rune_e_3_aura", {})
		-- end
		local maxSpirits = 3
		if caster:HasModifier("modifier_spirit_warrior_glyph_3_1") then
			maxSpirits = 5
		end
		if #ability.spiritTable > maxSpirits then
			removeSpirit(ability.spiritTable[1], ability, caster)
		end

	end
end

function ancient_spirit_attacking_think(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_ancient_vigor") then
		event.target:RemoveModifierByName("modifier_spirit_attacking")
	end
end

function ancient_spirit_particle(position, caster)
	position = position - Vector(0, 0, 30)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/spirit_warrior_spirit_pop.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, position)
	ParticleManager:SetParticleControl(pfx, 2, position)
	ParticleManager:SetParticleControl(pfx, 3, position)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function reindexSpiritTable(ability)
	local newTable = {}
	for i = 1, #ability.spiritTable, 1 do
		if IsValidEntity(ability.spiritTable[i]) then
			table.insert(newTable, ability.spiritTable[i])
		end
	end
	ability.spiritTable = newTable
end

function removeSpirit(spirit, ability, caster)
	ancient_spirit_particle(spirit:GetAbsOrigin(), caster)
	EmitSoundOn("SpiritWarrior.AncientSpiritDestroy", spirit)
	UTIL_Remove(spirit)
	reindexSpiritTable(ability)
end

function spirit_dashing_think(event)
	local caster = event.caster
	local ability = event.ability
	local spirit = ability.targetedSpirit
	if IsValidEntity(spirit) then
		local spiritOrigin = spirit:GetAbsOrigin()
		local casterOrigin = caster:GetAbsOrigin()
		local moveVector = ((spiritOrigin - casterOrigin) * Vector(1, 1, 0)):Normalized()
		local dashSpeed = 50
		if caster:HasModifier("modifier_spirit_warrior_glyph_1_1") then
			dashSpeed = math.floor(dashSpeed * 1.5)
		end
		dashSpeed = Filters:GetAdjustedESpeed(caster, dashSpeed, false)
		local newPosition = casterOrigin + moveVector * dashSpeed
		local obstruction = WallPhysics:FindNearestObstruction(newPosition)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, spirit)
		if not blockUnit then
			caster:SetAbsOrigin(newPosition)
			local distance = WallPhysics:GetDistance(spiritOrigin * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
			if distance < 50 then
				caster:RemoveModifierByName("modifier_spirit_dashing")
				WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
				reachSpirit(caster, ability, spirit:GetAbsOrigin())
				removeSpirit(spirit, ability, caster)
			end
		else
			caster:RemoveModifierByName("modifier_spirit_dashing")
			WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
			reachSpirit(caster, ability, spirit:GetAbsOrigin())
			removeSpirit(spirit, ability, caster)
		end

	end

end

function spirit_moving_out(event)
	local spirit = event.target
	local ability = event.ability

	local targetPoint = spirit.targetPoint
	local casterOrigin = spirit:GetAbsOrigin()
	local moveVector = ((targetPoint - casterOrigin) * Vector(1, 1, 0)):Normalized()
	local movespeed = 35
	movespeed = Filters:GetAdjustedESpeed(spirit.origCaster, movespeed, false)
	local newPosition = casterOrigin + moveVector * movespeed
	local checkPosition = casterOrigin + moveVector * (movespeed + 5)
	local obstruction = WallPhysics:FindNearestObstruction(checkPosition * Vector(1, 1, 0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, checkPosition * Vector(1, 1, 0), spirit)
	if not blockUnit then
		spirit:SetAbsOrigin(newPosition)
		local distance = WallPhysics:GetDistance(targetPoint * Vector(1, 1, 0), spirit:GetAbsOrigin() * Vector(1, 1, 0))
		if distance < 60 then
			Timers:CreateTimer(0.03, function()
				spirit:SetAbsOrigin(GetGroundPosition(targetPoint, spirit))
			end)
			spirit:RemoveModifierByName("modifier_spirit_moving_out")
			EndAnimation(spirit)
			spirit:SetAbsOrigin(spirit:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(spirit:GetAbsOrigin(), spirt)))
		end
	else
		spirit:RemoveModifierByName("modifier_spirit_moving_out")
		EndAnimation(spirit)
	end
end

function reachSpirit(caster, ability, spiritPosition)
	local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "spirit_warrior")
	if w_4_level > 0 then
		local runeAbility = caster.runeUnit4:FindAbilityByName("spirit_warrior_rune_w_4")
		local duration = Filters:GetAdjustedBuffDuration(caster, 30, false)
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_spirit_warrior_d_b", {duration = duration})
		runeAbility.level = w_4_level
	end
	local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "spirit_warrior")
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "spirit_warrior")
	if a_c_level > 0 then
		local loops = 1
		if caster:HasModifier("modifier_spirit_warrior_glyph_4_1") then
			loops = 5
		end
		for i = 0, loops - 1, 1 do
			Timers:CreateTimer(i * 0.75, function()
				EmitSoundOnLocationWithCaster(spiritPosition, "SpiritWarrior.ACExplosion", caster)
				local particleName = "particles/units/heroes/hero_ember_spirit/spirit_warrior_c_a_wind_edict.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, spiritPosition)
				ParticleManager:SetParticleControl(pfx, 1, spiritPosition)
				ParticleManager:SetParticleControl(pfx, 2, spiritPosition)
				ParticleManager:SetParticleControl(pfx, 3, spiritPosition)
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), spiritPosition, nil, 410, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					local damage = SPIRIT_WARRIOR_E1_DMG * a_c_level
					for _, enemy in pairs(enemies) do
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
						if caster:HasModifier("modifier_windstrike_weapon") then
							if a_c_level > 0 then
								local windstrikeEvent = {}
								windstrikeEvent.attacker = caster
								windstrikeEvent.target = enemy
								windstrikeEvent.ability = caster:FindAbilityByName("spirit_warrior_windstrike_weapon")
								windstrikeEvent.mult = SPIRIT_WARRIOR_E1_BONUS_WINDSRIKE_PCT/100 * a_c_level
								windstrike_attack_land(windstrikeEvent)
							end
						end
					end
				end
			end)
		end
	end
	local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "spirit_warrior")
	if c_c_level > 0 then
		EmitSoundOnLocationWithCaster(spiritPosition, "SpiritWarrior.TempestHaze", caster)
		local duration = SPIRIT_WARRIOR_E3_DURATION_BASE + c_c_level * SPIRIT_WARRIOR_E3_DURATION
		local stormParticle = ParticleManager:CreateParticle("particles/roshpit/spirit_warrior/tempest_haze_storm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(stormParticle, 0, spiritPosition)
		ParticleManager:SetParticleControl(stormParticle, 1, Vector(800, 2, 2))
		ParticleManager:SetParticleControl(stormParticle, 2, Vector(duration, duration, duration))
		--ability:ApplyDataDrivenThinker(caster, spiritPosition, "modifier_tempest_haze_aura_thinker_enemy", {duration = duration})
		CustomAbilities:QuickAttachThinker(ability, caster, spiritPosition, "modifier_tempest_haze_aura_thinker_enemy", {duration = duration})
		--ability:ApplyDataDrivenThinker(caster, spiritPosition, "modifier_tempest_haze_aura_thinker_friendly", {duration = duration})
		CustomAbilities:QuickAttachThinker(ability, caster, spiritPosition, "modifier_tempest_haze_aura_thinker_friendly", {duration = duration})

		ability.e_3_damage_tick = SPIRIT_WARRIOR_E3_DPS * c_c_level * 0.5
	end
	-- "particles/roshpit/spirit_warrior/tempest_haze_storm.vpcf"

end

function b_c_start(event)
	local ability = event.ability
	if ability.level then
		local caster = event.caster
		local target = event.target
		target:SetModifierStackCount("modifier_spirit_rune_e_2_buff", caster, ability.level)
	end
end

function c_c_start(event)
	local ability = event.ability
	if ability.level then
		local caster = event.caster
		local target = event.target
		target:SetModifierStackCount("modifier_spirit_rune_e_3_debuff", caster, ability.level)
	end
end

function ancient_spirit_attack_hit(event)
	local attacker = event.attacker
	local target = event.target
	local origCaster = attacker.origCaster
	local damage = attacker.r_3_level * 0.5 * OverflowProtectedGetAverageTrueAttackDamage(origCaster)
	Filters:TakeArgumentsAndApplyDamage(target, origCaster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_WIND)
end

function ancient_attacking_end(event)
	local target = event.target
	local origCaster = target.origCaster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(origCaster, target, "modifier_ancient_spirit_disarm", {})
end

function c_c_think(event)
	local hero = event.caster.hero
	if hero:HasModifier("modifier_spirit_warrior_glyph_4_1") then
		local luck = RandomInt(1, 6)
		if luck == 1 then
			event.ability:ApplyDataDrivenModifier(event.caster, event.target, "modifier_spirit_glyph_root", {duration = 3})
		end
	end
end

function tempest_haze_enemy_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.e_3_damage_tick, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_WIND, RPC_ELEMENT_LIGHTNING)
end

function tempest_haze_friendly_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target:HasModifier("modifier_spirit_warrior_glyph_5_a") then
		local modifier = target:FindModifierByName("modifier_spirit_warrior_glyph_5_a")
		local glyphUnit = modifier:GetCaster()
		local glyph = modifier:GetAbility()
		local buffDuration = Filters:GetAdjustedBuffDuration(caster, 6, false)
		glyph:ApplyDataDrivenModifier(glyphUnit, target, "modifier_spirit_warrior_glyph_5_a_effect", {duration = buffDuration})
		local newStacks = target:GetModifierStackCount("modifier_spirit_warrior_glyph_5_a_effect", glyphUnit) + 1
		target:SetModifierStackCount("modifier_spirit_warrior_glyph_5_a_effect", glyphUnit, newStacks)
	end
end
