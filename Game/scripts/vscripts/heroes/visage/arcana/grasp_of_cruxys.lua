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
					if ability:GetAbilityName() == "ekkan_arcana2_frost_wraith" then
						unitName = "ekkan_frost_wraith"
						colorVector = Vector(0, 125, 255)
					elseif ability:GetAbilityName() == "ekkan_arcana2_burning_legionnaire" then
						unitName = "ekkan_burning_legionnaire"
						colorVector = Vector(255, 0, 0)
					end

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
					skeleton:SetAcquisitionRange(800)

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
					if unitName ~= "ekkan_burning_legionnaire" then
						EmitSoundOn("Ekkan.SkeletonSpawn", skeleton)
					end

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
					elseif unitName == "ekkan_frost_wraith" then
						skeleton:AddAbility("ekkan_frost_wraith_passive"):SetLevel(ability:GetLevel())
						if skeleton.w_3_level > 0 then
							skeleton:AddAbility("ekkan_frost_wraith_freezing_rain"):SetLevel(1)
						end
					elseif unitName == "ekkan_burning_legionnaire" then
						skeleton:AddAbility("ekkan_burning_legionnaire_passive"):SetLevel(ability:GetLevel())
						if skeleton.w_2_level > 0 then
							skeleton_ability = skeleton:FindAbilityByName("ekkan_burning_legionnaire_passive")
							skeleton_ability:ApplyDataDrivenModifier(skeleton, skeleton, "modifier_burning_legionnaire_cloak_of_flame_aura", {})
						end
						if skeleton.w_3_level > 0 then
							skeleton:AddAbility("ekkan_burning_legionnaire_skeletal_mortar"):SetLevel(1)
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
	elseif attacker:GetUnitName() == "ekkan_frost_wraith" then
		EmitSoundOn("Ekkan.FrostWraith.Attack", attacker)
	elseif attacker:GetUnitName() == "ekkan_burning_legionnaire" then
		EmitSoundOn("Ekkan.BurningLegionnaire.Attack", attacker)
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

function frost_wraith_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local hero = caster.hero
	ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_wraith_basic_chilled", {duration = event.cold_duration})
	if attacker.w_1_level > 0 then
		local chance = RandomInt(1, 100)
		if chance <= EKKAN_ARCANA_W1B_CHANCE then
			local icePoint = target:GetAbsOrigin()
			local radius = EKKAN_ARCANA_W1B_RADIUS
			local root_duration = EKKAN_ARCANA_W1B_BASE_DURATION + EKKAN_ARCANA_W1B_ROOT_DURATION*attacker.w_1_level
			local damage = attacker:GetRoshpitMagicArmor()*(EKKAN_ARCANA_W1B_DAMAGE_PCT_MAGIC_ARMOR/100)*caster.w_1_level
			EmitSoundOnLocationWithCaster(icePoint, "Ekkan.FrostWraith.IceBlast", caster)
			local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
			local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, icePoint)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frost_wraith_w_1_root", {duration = root_duration})
					Filters:TakeArgumentsAndApplyDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_ICE)
				end
			end
		end
	end
end

function frost_wraith_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local hero = caster.hero
	if caster.w_2_level > 0 then
		local chance = RandomInt(1, 100)
		if chance <= EKKAN_ARCANA_W2B_CHANCE then
			local radius = EKKAN_ARCANA_W2B_BASE_RADIUS + EKKAN_ARCANA_W2B_RADIUS * caster.w_2_level
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				EmitSoundOn("Ekkan.FrostWraith.IcicleThrow", caster)
				for i = 1, EKKAN_ARCANA_W2B_SPEAR_COUNT, 1 do
					local enemy = enemies[i]
					if enemy then
						local info =
						{
							Target = enemy,
							Source = caster,
							Ability = ability,
							EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
							vSourceLoc = caster:GetAbsOrigin(),
							bDrawsOnMinimap = false,
							bDodgeable = true,
							bIsAttack = false,
							bVisibleToEnemies = true,
							bReplaceExisting = false,
							flExpireTime = GameRules:GetGameTime() + 10,
							bProvidesVision = true,
							iVisionRadius = 0,
							iMoveSpeed = 900,
						iVisionTeamNumber = caster:GetTeamNumber()}
						projectile = ProjectileManager:CreateTrackingProjectile(info)
					end
				end
			end			
		end
	end
end

function frost_wraith_w2_projectile_hit(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local hero = caster.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(EKKAN_ARCANA_W2B_DMG_PCT_ATK_POWER/100)
	EmitSoundOn("Ekkan.FrostWraith.IcicleImpact", target)
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_ICE)
end

function frost_wraith_think(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("ekkan_frost_wraith_freezing_rain")
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

function frost_wraith_freezing_rain_cast(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local hero = caster.hero
	local position = event.target_points[1]

	local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
	local pfx_table = {}
	local fv = caster:GetForwardVector()
	local pfx_positions = {}
	table.insert(pfx_positions, position+RandomVector(RandomInt(20, 40)))
	-- for i = 1, 6, 1 do
	-- 	local ice_position = position + WallPhysics:rotateVector(fv, 2*math.pi*i/6)*RandomInt(EKKAN_ARCANA_W3B_RADIUS*0.8, EKKAN_ARCANA_W3B_RADIUS-30)
	-- 	table.insert(pfx_positions, ice_position)
	-- end
	for i = 1, 5, 1 do
		local ice_position = position + WallPhysics:rotateVector(fv, 2*math.pi*i/5)*RandomInt(EKKAN_ARCANA_W3B_RADIUS*0.5, EKKAN_ARCANA_W3B_RADIUS-120)
		table.insert(pfx_positions, ice_position)
	end
	WallPhysics:ShuffleTable(pfx_positions)
	for j = 1, #pfx_positions, 1 do
		Timers:CreateTimer(j*0.03, function()
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, pfx_positions[j])
			table.insert(pfx_table, pfx)
		end)
	end

	EmitSoundOn("Ekkan.FrostWraith.FreezingRain.Cast", caster)
	local radius = EKKAN_ARCANA_W3B_RADIUS
	local damage = caster:GetRoshpitSpellPierce()*(EKKAN_ARCANA_W3B_DMG_SPELL_PIERCE/100)*caster.w_3_level
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	Timers:CreateTimer(EKKAN_ARCANA_W3B_DAMAGE_DELAY, function()
		EmitSoundOnLocationWithCaster(position, "Ekkan.FrostWraith.FreezingRain.Impact", caster)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_ICE)
				ability:ApplyDataDrivenModifier(caster, enemy, "frost_wraith_freezing_rain_effect", {duration = EKKAN_ARCANA_W3B_PCT_SLOW_DURATION})
				enemy:SetModifierStackCount("frost_wraith_freezing_rain_effect", caster, caster.w_3_level)
			end
		end
	end)
	Timers:CreateTimer(1, function()
		for i = 1, #pfx_table, 1 do
			ParticleManager:DestroyParticle(pfx_table[i], false)
		end
	end)
end

function burning_legionnaire_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local hero = caster.hero
	local target = event.target

	local damage = (event.fire_damage/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/burning_legionnaire_attack.vpcf", target, 0.5)
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_FIRE)
end

function die_near_burning_legionnaire(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local hero = caster.hero
	local target = event.unit
	if target:GetEnemyTier() <= ENEMY_TYPE_WEAK_CREEP then
		return false
	end
	local range = EKKAN_ARCANA_W1C_RANGE

	local playSound = true
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			if ally:GetUnitName() == "ekkan_burning_legionnaire" then
				if ally.w_1_level > 0 then
					local stacks = ally:GetModifierStackCount("modifier_burning_legionnaire_w_1_visible", ally)
					local new_stacks = stacks + 1
					ally:RemoveModifierByName("modifier_burning_legionnaire_w_1_visible")
					local ally_ability = ally:FindAbilityByName(ability:GetAbilityName())
					ally_ability:ApplyDataDrivenModifier(ally, ally, "modifier_burning_legionnaire_w_1_visible", {})
					ally:SetModifierStackCount("modifier_burning_legionnaire_w_1_visible", ally, new_stacks)
					ally_ability:ApplyDataDrivenModifier(ally, ally, "modifier_burning_legionnaire_w_1_effect", {})
					ally:SetModifierStackCount("modifier_burning_legionnaire_w_1_effect", ally, new_stacks*ally.w_1_level)
					if playSound then
						EmitSoundOn("Ekkan.BurningLegionnaire.W1Buff", ally)
						playSound = false
					end
				end
			end
		end
	end
end

function burning_legionnaire_cloak_of_flames_burning_think(event)
	local target = event.target
	local caster = event.caster
	local hero = event.caster.hero
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(EKKAN_ARCANA_W2C_BURN_DAMAGE/100)*caster.w_2_level
	Filters:TakeArgumentsAndApplyDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_FIRE)
end

function burning_legionnaire_skeletal_mortar_cast(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local hero = caster.hero
	local position = event.target_points[1]
	EmitSoundOn("Ekkan.BurningLegionnaire.Mortar.Cast", caster)
	caster:AddNoDraw()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_skeletal_mortar_wait", {})

	local max_distance = EKKAN_ARCANA_W3C_RANGE_BASE + EKKAN_ARCANA_W3C_RANGE*caster.w_3_level
	local cast_distance = WallPhysics:GetDistance2d(position, caster:GetAbsOrigin())
	local fv = ((position - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local actual_distance = cast_distance
	if cast_distance > max_distance then
		position = caster:GetAbsOrigin() + fv*max_distance
		actual_distance = max_distance
	end
	local projectile_speed = 1000
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, position)
	ParticleManager:SetParticleControl(pfx, 2, Vector(projectile_speed, projectile_speed, projectile_speed))
	-- ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 4, fv*actual_distance)

	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", caster:GetAbsOrigin(), 2)
	local delay = actual_distance/projectile_speed
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(EKKAN_ARCANA_W3C_IMPACT_DMG/100)*caster.w_3_level
	Timers:CreateTimer(delay, function()
		FindClearSpaceForUnit(caster, position, false)
		ParticleManager:DestroyParticle(pfx, false)
		caster:RemoveNoDraw()
		caster:RemoveModifierByName("modifier_skeletal_mortar_wait")
		EmitSoundOn("Ekkan.BurningLegionnaire.Mortar.Impact", caster)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/ekkan/burning_legionnaire_mortar_ground.vpcf", caster:GetAbsOrigin(), 3)
		CustomAbilities:QuickParticleAtPoint("particles/neutral_fx/roshan_slam.vpcf", caster:GetAbsOrigin(), 3)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, EKKAN_ARCANA_W3C_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_FIRE)
			end
		end
	end)
end

function burning_legionnaire_think(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("ekkan_burning_legionnaire_skeletal_mortar")
	if ability then
		if ability:IsFullyCastable() then
			local max_distance = EKKAN_ARCANA_W3C_RANGE_BASE + EKKAN_ARCANA_W3C_RANGE*caster.w_3_level
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, max_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
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