require("/heroes/visage/ekkan_constants")

function corpse_maker_die(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.unit
	if unit:GetUnitName() == "ekkan_corpse" then
		return false
	end
	if not unit:HasModifier("modifier_ekkan_dominion_debuff") then
		local corpses = 1
		if unit:HasModifier("modifier_swarm_effect") then
			corpses = 2
		end
		for i = 1, corpses, 1 do
			local position = unit:GetAbsOrigin()
			if i > 1 then
				position = position + RandomVector(90)
			end
			local corpse = CreateUnitByName("ekkan_corpse", position, false, nil, nil, unit:GetTeamNumber())
			ability:ApplyDataDrivenModifier(caster, corpse, "modifier_ekkan_skeleton_corpse", {duration = 30})
			corpse:SetForwardVector(RandomVector(1))
			corpse.hp = unit:GetMaxHealth()
			corpse.attackpower = OverflowProtectedGetAverageTrueAttackDamage(unit)
			corpse.dummy = true
		end
	end
end

function cast_raise_skeleton_cruxys(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local point = event.target_points[1]
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 105, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy:GetUnitName() == "ekkan_corpse" then
				local target = enemy
				local summonPosition = enemy:GetAbsOrigin()
				Timers:CreateTimer(0.2, function()
					UTIL_Remove(target)
					local unitName = "ekkan_plaguebearer"
					local colorVector = Vector(100, 255, 120)
					local attackDamage = caster:GetAttackDamage() * event.attack_mult
					local luck = RandomInt(1, 10)


					local skeleton = CreateUnitByName(unitName, summonPosition, false, nil, nil, caster:GetTeamNumber())
					skeleton:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
					local skeletonDuration = event.skeleton_duration
					skeleton:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
					local w_4_level = caster:GetRuneValue("w", 4)
					if w_4_level > 0 then
						skeletonDuration = skeletonDuration + EKKAN_ARCANA_W4A_DURATION_INCREASE * w_4_level
					end
					if caster:HasModifier("modifier_ekkan_glyph_3_1") then
						skeletonDuration = skeletonDuration + skeletonDuration * EKKAN_GLYPH_3_1_SKELETON_DURATION_INCREASE_PCT/100
					end

					skeletonDuration = Filters:GetAdjustedBuffDuration(caster, skeletonDuration, false)
					ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_skeleton_summon_unit", {duration = skeletonDuration})
					local skeleArmor = caster:GetRoshpitArmor() * event.armor_mult
					local skeleMagicArmor = caster:GetRoshpitMagicArmor() * event.armor_mult

					local skele_armor_pierce = caster:GetRoshpitArmorPierce()
					local skele_spell_pierce = caster:GetRoshpitSpellPierce()
					--print(skeleArmor)
					--print("------")
					skeleton:SetBaseRoshpitArmor(skeleArmor)
					skeleton:SetBaseRoshpitMagicArmor(skeleMagicArmor)
					skeleton:SetBaseRoshpitArmorPierce(skele_armor_pierce)
					skeleton:SetBaseRoshpitSpellPierce(skele_spell_pierce)
					skeleton:SetBaseDamageMin(attackDamage)
					skeleton:SetBaseDamageMax(attackDamage)

					if not ability.skeleTable then
						ability.skeleTable = {}
					end
					local skeleton_health = caster:GetMaxHealth()*(event.skeleton_health/100)
					skeleton:SetMaxHealth(skeleton_health)
					skeleton:SetBaseMaxHealth(skeleton_health)
					skeleton:SetHealth(skeleton_health)
					skeleton.ekkan_unit = true
					skeleton.hero = caster
					skeleton.ekkan_dominion = true
					skeleton.dominion = true

					skeleton.w_1_level = caster:GetRuneValue("w", 1)
					skeleton.w_2_level = caster:GetRuneValue("w", 2)
					skeleton.w_3_level = caster:GetRuneValue("w", 3)

					table.insert(ability.skeleTable, skeleton)
					local max_skeletons = event.max_skeletons
					if caster:HasModifier("modifier_ekkan_glyph_1_1") then
						max_skeletons = max_skeletons + EKKAN_GLYPH_1_1_ADD_UNITS
					end
					if #ability.skeleTable > max_skeletons then
						if IsValidEntity(ability.skeleTable[1]) then
							ability.skeleTable[1]:ForceKill(false)
						end
					end

					reindexSkeleTable(ability)
					StartAnimation(skeleton, {duration = 0.6, activity = ACT_DOTA_SPAWN, rate = 0.8})
					ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_skeleton_spawning", {duration = 0.5})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", skeleton, 3)
					EmitSoundOn("Ekkan.SkeletonSpawn", skeleton)

					skeleton:SetRoshpitLevel(caster:GetLevel())
					skeleton.stance = "aggressive"
					skeleton:SetOwner(caster)
					FindClearSpaceForUnit(skeleton, skeleton:GetAbsOrigin(), false)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_summon_skeleton_counter", {})
					caster:SetModifierStackCount("modifier_summon_skeleton_counter", caster, #ability.skeleTable)
					skeleton.owner = caster:GetPlayerOwnerID()
					skeleton:CalculateAndSaveRoshpitAttributes()

					if unitName == "ekkan_plaguebearer" then
						skeleton:AddAbility("ekkan_plaguebearer_passive"):SetLevel(ability:GetLevel())
						if skeleton.w_3_level > 0 then
							skeleton:AddAbility("ekkan_plaguebearer_poison_spray"):SetLevel(1)
						end
						if skeleton.w_2_level > 0 then
							skeleton_ability = skeleton:FindAbilityByName("ekkan_plaguebearer_passive")
							skeleton_ability:ApplyDataDrivenModifier(skeleton, skeleton, "modifier_plaguebearer_rot_aura", {})
						end
					end
				end)

				local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(beamPFX, 1, summonPosition)
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(beamPFX, false)
					ParticleManager:ReleaseParticleIndex(beamPFX)
				end)
			end
		end
	end
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function reindexSkeleTable(ability)
	local newTable = {}
	for i = 1, #ability.skeleTable, 1 do
		if IsValidEntity(ability.skeleTable[i]) then
			if ability.skeleTable[i]:IsAlive() then
				table.insert(newTable, ability.skeleTable[i])
			end
		end
	end
	ability.skeleTable = newTable
end

function remove_corpse(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target.disable = true
	for i = 1, 30, 1 do
		Timers:CreateTimer(i * 0.03, function()
			target:SetRenderColor(255 - i * 7, 255 - i * 7, 255 - i * 7)
			target:SetAbsOrigin(target:GetAbsOrigin() - Vector(0, 0, 2.5))
		end)
	end
	Timers:CreateTimer(1, function()
		UTIL_Remove(target)
	end)
end

function skeleton_die(event)
	local ability = event.ability
	local caster = event.caster
	reindexSkeleTable(ability)
	--print("SKELETON DIE")
	--print(#ability.skeleTable)
	if #ability.skeleTable > 0 then
		caster:SetModifierStackCount("modifier_summon_skeleton_counter", caster, #ability.skeleTable)
	else
		caster:RemoveModifierByName("modifier_summon_skeleton_counter")
	end
end

function skeleton_expire(event)
	local target = event.target
	if not target:HasModifier("modifier_ekkan_dominion_unit") then
		target:ForceKill(false)
	end
	local caster = event.caster
	local ability = event.ability
	reindexSkeleTable(ability)
	--print("SKELETON DIE")
	--print(#ability.skeleTable)
	if #ability.skeleTable > 0 then
		caster:SetModifierStackCount("modifier_summon_skeleton_counter", caster, #ability.skeleTable)
	else
		caster:RemoveModifierByName("modifier_summon_skeleton_counter")
	end
end

function skeleton_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if attacker:GetUnitName() == "ekkan_plaguebearer" then
		EmitSoundOn("Ekkan.PlagueBearer.AttackLand", attacker)
	end
end

function plaguebearer_basic_poison_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
end

function plaguebearer_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_plaguebearer_basic_poison", {duration = event.poison_duration})
end

function plaguebearer_basic_poison_think(event)
	local target = event.target
	local caster = event.caster
	local hero = event.caster.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.poison_damage/100)
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)
end

function plaguebearer_attacked(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if caster.w_1_level > 0 then
		local duration = EKKAN_ARCANA_W1A_BASE_DURATION + caster.w_1_level * EKKAN_ARCANA_W1A_DURATION
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_plaguebearer_w_1_poison", {duration = duration})
	end
end

function plaguebearer_corrosive_skin_think(event)
	local target = event.target
	local caster = event.caster
	local hero = event.caster.hero
	local damage = caster:GetRoshpitArmor()*(EKKAN_ARCANA_W1A_DAMAGE_PCT_ARMOR/100)*caster.w_1_level
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)
end

function plaguebearer_rot_think(event)
	local target = event.target
	local caster = event.caster
	local hero = event.caster.hero
	local ability = event.ability
	local damage = caster:GetMaxHealth()*(EKKAN_ARCANA_W2A_DAMAGE_PCT_MAX_HEALTH/100)*caster.w_2_level
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_plaguebearer_rot_ms_loss", {})
	target:SetModifierStackCount("modifier_plaguebearer_rot_ms_loss", caster, caster.w_2_level*EKKAN_ARCANA_W2A_MOVESLOW)
end

function plaguebearer_think(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("ekkan_plaguebearer_poison_spray")
	if ability then
		if ability:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				if caster.position_cast_self then
					castPoint = caster:GetAbsOrigin()
				end
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function plaguebearer_poison_spray_cast(event)
	local caster = event.caster
	local hero = event.caster.hero
	local ability = event.ability
	local position = event.target_points[1]
	EmitSoundOnLocationWithCaster(position, "Ekkan.PlagueBearer.AcidSpray", caster)

    local poison_thinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, hero:GetTeamNumber())

    poison_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	poison_thinker:SetAbsOrigin(position)
    poison_thinker:SetDayTimeVisionRange(0)
    poison_thinker:SetNightTimeVisionRange(0)

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, poison_thinker:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(EKKAN_ARCANA_W3A_RADIUS, 1, 1))
    ParticleManager:SetParticleControl(pfx, 15, Vector(60, 255, 60))
    ParticleManager:SetParticleControl(pfx, 16, Vector(1, 1, 1))
    poison_thinker.pfx = pfx

    local puddle_duration = EKKAN_ARCANA_W3A_DURATION
    ability:ApplyDataDrivenModifier(caster, poison_thinker, "plague_bearer_acid_spray_thinker", {duration = puddle_duration})
end

function plaguebearer_poison_spray_thinker_end(event)
	print("END POISON SPRAY")
	local target = event.target
	ParticleManager:DestroyParticle(target.pfx, false)
	UTIL_Remove(target)
end

function plaguebearer_poison_spray_think(event)
	local caster = event.caster
	local hero = event.caster.hero
	local ability = event.ability
	local target = event.target
	print(hero:GetUnitName())
	local damage = caster:GetRoshpitArmorPierce()*(EKKAN_ARCANA_W3A_DAMAGE_PCT_ARMOR_PIERCE/100)*caster.w_3_level
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)
end